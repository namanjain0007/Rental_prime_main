const supabase = require("../config/supabase");
const { createClient } = require("@supabase/supabase-js");
const config = require("../config/config");

// Initialize Supabase client
const supabaseClient = createClient(config.supabaseUrl, config.supabaseKey);

// @desc    Get all admin users
// @route   GET /api/admins
// @access  Private/SuperAdmin
exports.getAdminUsers = async (req, res) => {
  try {
    // Get all admin users with their role information
    const {
      data: adminUsers,
      error,
      count,
    } = await supabase
      .from("admin_users")
      .select("*, roles(name, description, permissions)", { count: "exact" });

    if (error) {
      throw new Error(error.message);
    }

    res.status(200).json({
      success: true,
      count: count,
      data: adminUsers,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// @desc    Get single admin user
// @route   GET /api/admins/:id
// @access  Private/SuperAdmin
exports.getAdminUser = async (req, res) => {
  try {
    const { data: adminUser, error } = await supabase
      .from("admin_users")
      .select("*, roles(name, description, permissions)")
      .eq("id", req.params.id)
      .single();

    if (error) {
      return res.status(404).json({
        success: false,
        message: `Admin user not found with id of ${req.params.id}`,
      });
    }

    res.status(200).json({
      success: true,
      data: adminUser,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// @desc    Create admin user
// @route   POST /api/admins
// @access  Private/SuperAdmin
exports.createAdminUser = async (req, res) => {
  try {
    const { name, email, password, status, user_type, role_id } = req.body;

    // Validate required fields
    if (!name || !email || !password || !user_type) {
      return res.status(400).json({
        success: false,
        message: "Please provide name, email, password, and user_type",
      });
    }

    // Validate user_type - only allow super_admin for admin_users table
    if (user_type !== "super_admin") {
      return res.status(400).json({
        success: false,
        message:
          "Invalid user_type. Only 'super_admin' is allowed for admin_users table. Use /api/users for vendor and customer users.",
      });
    }

    // Check if admin user already exists in Supabase
    const { data: existingAdmins, error: checkError } = await supabase
      .from("admin_users")
      .select("email")
      .eq("email", email)
      .limit(1);

    if (checkError) {
      throw new Error(checkError.message);
    }

    if (existingAdmins && existingAdmins.length > 0) {
      return res.status(400).json({
        success: false,
        message: "Admin user already exists",
      });
    }

    // If role_id is not provided, get the appropriate role based on user_type
    let adminRoleId = role_id;
    if (!adminRoleId) {
      // Map user_type to role name for admin users
      const roleName = user_type === "superadmin" ? "super_admin" : user_type;

      const { data: roleData, error: roleError } = await supabase
        .from("roles")
        .select("id")
        .eq("name", roleName)
        .single();

      if (roleError) {
        throw new Error(
          `Role not found for user type ${user_type}. Error: ${roleError.message}`
        );
      }

      adminRoleId = roleData.id;
    }

    // Create admin user in Supabase Auth
    const { data: authData, error: authError } =
      await supabase.auth.admin.createUser({
        email,
        password,
        email_confirm: true,
      });

    if (authError) {
      throw new Error(authError.message);
    }

    // Create admin user profile in admin_users table
    const { data: adminUserData, error: adminUserError } = await supabase
      .from("admin_users")
      .insert([
        {
          id: authData.user.id, // Use the auth user's ID
          email,
          name,
          password, // Include password as required by schema
          user_type,
          role_id: adminRoleId, // Reference to the roles table
          status: status || "active",
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      ])
      .select();

    if (adminUserError) {
      throw new Error(adminUserError.message);
    }

    res.status(201).json({
      success: true,
      data: adminUserData[0],
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// @desc    Update admin user
// @route   PUT /api/admins/:id
// @access  Private/SuperAdmin
exports.updateAdminUser = async (req, res) => {
  try {
    const updateData = { ...req.body };

    // Validate user_type if being updated - only allow super_admin for admin_users table
    if (updateData.user_type && updateData.user_type !== "super_admin") {
      return res.status(400).json({
        success: false,
        message:
          "Invalid user_type. Only 'super_admin' is allowed for admin_users table. Use /api/users for vendor and customer users.",
      });
    }

    // First, get the current admin user data to check what's being updated
    const { data: currentAdminUser, error: getCurrentError } = await supabase
      .from("admin_users")
      .select("email")
      .eq("id", req.params.id)
      .single();

    if (getCurrentError) {
      return res.status(404).json({
        success: false,
        message: `Admin user not found with id of ${req.params.id}`,
        error: getCurrentError.message,
      });
    }

    // Check if email is being updated and update Supabase Auth if needed
    if (updateData.email && updateData.email !== currentAdminUser.email) {
      try {
        const { error: authUpdateError } =
          await supabase.auth.admin.updateUserById(req.params.id, {
            email: updateData.email,
          });

        if (authUpdateError) {
          throw new Error(
            `Failed to update auth email: ${authUpdateError.message}`
          );
        }
      } catch (authError) {
        return res.status(400).json({
          success: false,
          message: "Failed to update admin user authentication",
          error: authError.message,
        });
      }
    }

    // Handle password update if provided
    if (updateData.password) {
      try {
        const { error: authPasswordError } =
          await supabase.auth.admin.updateUserById(req.params.id, {
            password: updateData.password,
          });

        if (authPasswordError) {
          throw new Error(
            `Failed to update auth password: ${authPasswordError.message}`
          );
        }
      } catch (authError) {
        return res.status(400).json({
          success: false,
          message: "Failed to update admin user password",
          error: authError.message,
        });
      }
    }

    // Set updated_at timestamp
    updateData.updated_at = new Date().toISOString();

    // Update admin user in Supabase admin_users table
    const { data: adminUser, error } = await supabase
      .from("admin_users")
      .update(updateData)
      .eq("id", req.params.id)
      .select("*, roles(name, description, permissions)")
      .single();

    if (error) {
      return res.status(404).json({
        success: false,
        message: `Admin user not found with id of ${req.params.id}`,
        error: error.message,
      });
    }

    res.status(200).json({
      success: true,
      data: adminUser,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};

// @desc    Delete admin user
// @route   DELETE /api/admins/:id
// @access  Private/SuperAdmin
exports.deleteAdminUser = async (req, res) => {
  try {
    // First check if admin user exists
    const { data: adminUser, error: checkError } = await supabase
      .from("admin_users")
      .select("id, email")
      .eq("id", req.params.id)
      .single();

    if (checkError || !adminUser) {
      return res.status(404).json({
        success: false,
        message: `Admin user not found with id of ${req.params.id}`,
      });
    }

    // Get the user's auth ID from their email
    const { data: authUser, error: authUserError } =
      await supabase.auth.admin.listUsers();

    if (authUserError) {
      throw new Error(authUserError.message);
    }

    const matchedAuthUser = authUser.users.find(
      (u) => u.email === adminUser.email
    );

    if (matchedAuthUser) {
      // Delete admin user from Supabase Auth
      const { error: authError } = await supabase.auth.admin.deleteUser(
        matchedAuthUser.id
      );

      if (authError) {
        throw new Error(authError.message);
      }
    }

    // Delete admin user from admin_users table
    const { error: deleteError } = await supabase
      .from("admin_users")
      .delete()
      .eq("id", req.params.id);

    if (deleteError) {
      throw new Error(deleteError.message);
    }

    res.status(200).json({
      success: true,
      data: {},
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "Server Error",
      error: error.message,
    });
  }
};
