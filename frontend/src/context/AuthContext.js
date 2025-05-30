import React, { createContext, useState, useContext, useEffect } from "react";
import { toast } from "react-hot-toast";
import authService from "../services/authService";

// Add console logs for debugging in production
console.log("AuthContext loaded");

const AuthContext = createContext();

export const useAuth = () => useContext(AuthContext);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [isAuthenticated, setIsAuthenticated] = useState(false);
  const [loading, setLoading] = useState(true);
  const [session, setSession] = useState(null);

  // Check if user is logged in on page load
  useEffect(() => {
    // Add a safety timeout to ensure loading state is cleared even if everything fails
    const safetyTimeout = setTimeout(() => {
      console.log("Safety timeout triggered - forcing loading state to false");
      setLoading(false);
    }, 5000); // 5 seconds max for initial auth check

    // Initial check for user session
    const checkCurrentSession = async () => {
      try {
        console.log("Starting initial auth check...");

        // Check for stored token and user data
        const token = localStorage.getItem("token");
        const storedUser = localStorage.getItem("user");

        if (token && storedUser) {
          try {
            const userData = JSON.parse(storedUser);

            // Try to get current user from API to verify token is still valid
            const currentUser = await authService.getCurrentUser();

            if (currentUser) {
              setUser(currentUser);
              setIsAuthenticated(true);
              console.log("Initial auth check: User data loaded successfully");
            } else {
              // Token might be invalid, use stored data as fallback
              console.warn("API returned null, using stored user data");
              setUser(userData);
              setIsAuthenticated(true);
            }
          } catch (error) {
            console.error(
              "Error parsing stored user or API call failed:",
              error
            );
            // Clear invalid data
            localStorage.removeItem("token");
            localStorage.removeItem("user");
            setUser(null);
            setIsAuthenticated(false);
          }
        } else {
          // No stored session found, ensure user is logged out
          console.log("No stored session found, user not authenticated");
          setUser(null);
          setIsAuthenticated(false);
        }
      } catch (error) {
        console.error("Error checking current session:", error);
        // On error, ensure user is logged out to prevent infinite loading
        setUser(null);
        setIsAuthenticated(false);
      } finally {
        // Always set loading to false to ensure UI is not stuck
        console.log("Auth check complete, setting loading to false");
        setLoading(false);
        clearTimeout(safetyTimeout);
      }
    };

    // Call the check immediately
    checkCurrentSession();
  }, []);

  // Login user with backend API
  const login = async (email, password) => {
    console.log("Attempting login with:", email);
    setLoading(true);

    try {
      // Authenticate with backend API
      const result = await authService.signIn(email, password);
      console.log("Authentication result:", result);

      // If we have a valid result with user data
      if (result && result.user) {
        console.log("Setting user from auth response:", result.user);
        setUser(result.user);
        setIsAuthenticated(true);

        // Set session if available
        if (result.session) {
          setSession(result.session);
        }

        // Store user data
        localStorage.setItem("user", JSON.stringify(result.user));
        if (result.session) {
          localStorage.setItem("session", JSON.stringify(result.session));
        }

        toast.success("Login successful");
        setLoading(false);
        return true;
      } else {
        throw new Error("Invalid credentials");
      }
    } catch (error) {
      console.error("Login error:", error);
      toast.error("Login failed. Please check your credentials.");
      setLoading(false);
      return false;
    }
  };

  // Logout user
  const logout = async () => {
    try {
      const result = await authService.signOut();

      // Always clear local state regardless of API result
      setSession(null);
      setUser(null);
      setIsAuthenticated(false);

      if (result.warning) {
        toast.success("Logged out locally. Server connection unavailable.");
        console.warn(result.warning);
      } else {
        toast.success("Logged out successfully");
      }
    } catch (error) {
      console.error("Logout error:", error);
      // Still clear user data even if logout API fails
      setSession(null);
      setUser(null);
      setIsAuthenticated(false);
      toast.success("Logged out locally");
    }
  };

  // Update user profile
  const updateProfile = async (userData) => {
    try {
      if (!user || !user.id) {
        throw new Error("User not authenticated");
      }

      const updatedUser = await authService.updateProfile(user.id, userData);
      setUser({ ...user, ...updatedUser });

      // Update stored user data
      localStorage.setItem("user", JSON.stringify({ ...user, ...updatedUser }));

      toast.success("Profile updated successfully");
      return true;
    } catch (error) {
      console.error("Profile update error:", error);
      toast.error(error.message || "Failed to update profile");
      return false;
    }
  };

  // Reset password
  const resetPassword = async (email) => {
    try {
      await authService.resetPassword(email);
      toast.success("Password reset instructions sent to your email");
      return true;
    } catch (error) {
      console.error("Password reset error:", error);
      toast.error(error.message || "Failed to send password reset");
      return false;
    }
  };

  return (
    <AuthContext.Provider
      value={{
        user,
        isAuthenticated,
        loading,
        session,
        login,
        logout,
        updateProfile,
        resetPassword,
      }}
    >
      {children}
    </AuthContext.Provider>
  );
};
