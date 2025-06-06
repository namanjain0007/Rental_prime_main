-- First, let's create some categories if they don't exist
INSERT INTO categories (id, name, description, created_at, updated_at)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Electronics', 'Electronic devices and gadgets', NOW(), NOW()),
  ('22222222-2222-2222-2222-222222222222', 'Furniture', 'Home and office furniture', NOW(), NOW()),
  ('33333333-3333-3333-3333-333333333333', 'Sports', 'Sports equipment and gear', NOW(), NOW()),
  ('44444444-4444-4444-4444-444444444444', 'Tools', 'Power tools and equipment', NOW(), NOW()),
  ('55555555-5555-5555-5555-555555555555', 'Vehicles', 'Cars, bikes, and other vehicles', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Create some users if they don't exist
INSERT INTO users (id, name, email, password, user_type, status, created_at, updated_at)
VALUES 
  -- Use the existing admin user ID
  ('1568d5cc-2f78-4b4a-8f2e-5ce8d3b0f6b4', 'Admin User', 'admin@gmail.com', '$2a$10$gEtfsS9RSv58Lw1jbSINNO1T/6DXoEwVtK8g5QJyy9Hevkj86Jl2u', 'vendor', 'active', NOW(), NOW()),
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Rajesh Kumar', 'rajesh@example.com', '$2a$10$xVqYLGUuJ9Qh0JMn1VIbUeUFJUqGYjXvJ.hJ1ew8Qm0YR9.6smJwC', 'vendor', 'active', NOW(), NOW()),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Priya Sharma', 'priya@example.com', '$2a$10$xVqYLGUuJ9Qh0JMn1VIbUeUFJUqGYjXvJ.hJ1ew8Qm0YR9.6smJwC', 'customer', 'active', NOW(), NOW()),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Amit Patel', 'amit@example.com', '$2a$10$xVqYLGUuJ9Qh0JMn1VIbUeUFJUqGYjXvJ.hJ1ew8Qm0YR9.6smJwC', 'vendor', 'active', NOW(), NOW())
ON CONFLICT (id) DO NOTHING;

-- Now insert dummy listings with Indian standards
INSERT INTO listings (
  title,
  description,
  price,
  location,
  user_id,
  category_id,
  brand,
  condition,
  specifications,
  price_period,
  deposit,
  min_duration,
  available_from,
  available_to,
  delivery,
  shipping,
  video,
  rental_terms,
  accept_deposit,
  cancellation,
  notes,
  is_featured,
  status,
  images
) VALUES
-- Electronics
(
  'Sony Alpha A7 III Mirrorless Camera',
  'Professional full-frame mirrorless camera with excellent low-light performance and 4K video recording capabilities. Perfect for photography enthusiasts and professional photographers.',
  3500,
  'Mumbai, Maharashtra',
  '1568d5cc-2f78-4b4a-8f2e-5ce8d3b0f6b4',
  '11111111-1111-1111-1111-111111111111',
  'Sony',
  'Like New',
  '[{"key": "Model", "value": "Alpha A7 III"}, {"key": "Sensor", "value": "Full-frame CMOS"}, {"key": "Resolution", "value": "24.2 MP"}, {"key": "Weight", "value": "650g"}]',
  'day',
  15000,
  2,
  '2025-06-01',
  '2025-12-31',
  true,
  500,
  'https://www.youtube.com/watch?v=example1',
  'Aadhar card required, security deposit required',
  true,
  'moderate',
  'Comes with extra battery, 64GB SD card, and carrying case',
  true,
  'active',
  '["https://example.com/images/sony_a7iii_1.jpg", "https://example.com/images/sony_a7iii_2.jpg"]'
),
(
  'Apple MacBook Pro M2 16-inch',
  'Latest MacBook Pro with M2 chip, 16GB RAM and 512GB SSD. Perfect for professionals, designers, and developers who need powerful computing on the go.',
  5000,
  'Bangalore, Karnataka',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '11111111-1111-1111-1111-111111111111',
  'Apple',
  'Excellent',
  '[{"key": "Processor", "value": "Apple M2"}, {"key": "RAM", "value": "16GB"}, {"key": "Storage", "value": "512GB SSD"}, {"key": "Display", "value": "16-inch Retina"}]',
  'day',
  25000,
  3,
  '2025-05-15',
  '2025-11-15',
  false,
  800,
  'https://www.youtube.com/watch?v=example2',
  'Government ID and credit card required for security',
  true,
  'strict',
  'Includes charger and protective sleeve',
  true,
  'active',
  '["https://example.com/images/macbook_pro_1.jpg", "https://example.com/images/macbook_pro_2.jpg"]'
),
(
  'DJI Mavic Air 2 Drone',
  'Compact drone with 4K camera, 34-minute flight time, and intelligent shooting modes. Great for aerial photography and videography.',
  2500,
  'Delhi, NCR',
  '1568d5cc-2f78-4b4a-8f2e-5ce8d3b0f6b4',
  '11111111-1111-1111-1111-111111111111',
  'DJI',
  'Good',
  '[{"key": "Camera", "value": "4K/60fps"}, {"key": "Flight Time", "value": "34 minutes"}, {"key": "Range", "value": "10 km"}, {"key": "Weight", "value": "570g"}]',
  'day',
  12000,
  1,
  '2025-05-20',
  '2025-10-20',
  true,
  600,
  'https://www.youtube.com/watch?v=example3',
  'Training session provided before rental, Aadhar card required',
  true,
  'moderate',
  'Includes extra batteries and carrying case',
  false,
  'active',
  '["https://example.com/images/dji_mavic_1.jpg", "https://example.com/images/dji_mavic_2.jpg"]'
),

-- Furniture
(
  'Godrej Interio L-Shaped Office Desk',
  'Modern L-shaped desk perfect for home office or small business. Spacious work surface with built-in cable management.',
  1500,
  'Pune, Maharashtra',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '22222222-2222-2222-2222-222222222222',
  'Godrej Interio',
  'Excellent',
  '[{"key": "Material", "value": "Engineered Wood"}, {"key": "Dimensions", "value": "160cm x 140cm x 75cm"}, {"key": "Color", "value": "Walnut"}, {"key": "Assembly", "value": "Required"}]',
  'week',
  5000,
  2,
  '2025-06-10',
  '2025-09-10',
  true,
  1200,
  'https://www.youtube.com/watch?v=example4',
  'Assembly and disassembly included in rental',
  true,
  'flexible',
  'Perfect for work-from-home setup',
  false,
  'active',
  '["https://example.com/images/office_desk_1.jpg", "https://example.com/images/office_desk_2.jpg"]'
),
(
  'Urban Ladder Sofa Set (3+1+1)',
  'Comfortable 5-seater sofa set with premium fabric upholstery. Perfect for living rooms and lounges.',
  3000,
  'Chennai, Tamil Nadu',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '22222222-2222-2222-2222-222222222222',
  'Urban Ladder',
  'Like New',
  '[{"key": "Material", "value": "Premium Fabric"}, {"key": "Seating", "value": "5 Persons"}, {"key": "Color", "value": "Grey"}, {"key": "Style", "value": "Contemporary"}]',
  'week',
  10000,
  4,
  '2025-05-25',
  '2025-08-25',
  true,
  2000,
  'https://www.youtube.com/watch?v=example5',
  'Professional cleaning done before delivery',
  true,
  'moderate',
  'Ideal for temporary home setup or events',
  true,
  'active',
  '["https://example.com/images/sofa_set_1.jpg", "https://example.com/images/sofa_set_2.jpg"]'
),

-- Sports
(
  'Hero Sprint Pro Mountain Bike',
  'High-performance mountain bike with 21-speed gears, disc brakes, and front suspension. Perfect for trail riding and city commuting.',
  800,
  'Hyderabad, Telangana',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '33333333-3333-3333-3333-333333333333',
  'Hero',
  'Good',
  '[{"key": "Frame", "value": "Aluminum Alloy"}, {"key": "Gears", "value": "21-Speed"}, {"key": "Brakes", "value": "Disc"}, {"key": "Tire Size", "value": "27.5 inch"}]',
  'day',
  4000,
  1,
  '2025-06-05',
  '2025-12-05',
  true,
  700,
  'https://www.youtube.com/watch?v=example6',
  'Helmet included with rental, Aadhar card required',
  true,
  'flexible',
  'Regular maintenance performed, recently serviced',
  false,
  'active',
  '["https://example.com/images/mountain_bike_1.jpg", "https://example.com/images/mountain_bike_2.jpg"]'
),
(
  'Yonex Astrox 100ZZ Badminton Racket',
  'Professional badminton racket used by top players. Features head-heavy balance for powerful smashes.',
  500,
  'Bangalore, Karnataka',
  '1568d5cc-2f78-4b4a-8f2e-5ce8d3b0f6b4',
  '33333333-3333-3333-3333-333333333333',
  'Yonex',
  'Excellent',
  '[{"key": "Weight", "value": "85g"}, {"key": "Balance", "value": "Head-heavy"}, {"key": "String Tension", "value": "20-30 lbs"}, {"key": "Grip Size", "value": "G4"}]',
  'day',
  2000,
  1,
  '2025-05-15',
  '2025-11-15',
  false,
  200,
  'https://www.youtube.com/watch?v=example7',
  'Shuttlecocks not included',
  true,
  'flexible',
  'Used by national level players',
  false,
  'active',
  '["https://example.com/images/badminton_racket_1.jpg", "https://example.com/images/badminton_racket_2.jpg"]'
),

-- Tools
(
  'Bosch Professional Drill Machine Set',
  'Heavy-duty drill machine with hammer function and complete accessory kit. Ideal for construction and DIY projects.',
  1200,
  'Mumbai, Maharashtra',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '44444444-4444-4444-4444-444444444444',
  'Bosch',
  'Good',
  '[{"key": "Power", "value": "800W"}, {"key": "Chuck Size", "value": "13mm"}, {"key": "Speed", "value": "0-3000 RPM"}, {"key": "Functions", "value": "Drill, Hammer, Screwdriver"}]',
  'day',
  5000,
  1,
  '2025-06-01',
  '2025-09-01',
  true,
  400,
  'https://www.youtube.com/watch?v=example8',
  'Safety instructions provided, Aadhar card required',
  true,
  'moderate',
  'Includes 100+ accessories and carrying case',
  false,
  'active',
  '["https://example.com/images/drill_set_1.jpg", "https://example.com/images/drill_set_2.jpg"]'
),
(
  'Honda Portable Generator 2kVA',
  'Reliable portable generator for outdoor events, construction sites, or backup power. Fuel-efficient and quiet operation.',
  2000,
  'Delhi, NCR',
  'cccccccc-cccc-cccc-cccc-cccccccccccc',
  '44444444-4444-4444-4444-444444444444',
  'Honda',
  'Excellent',
  '[{"key": "Power Output", "value": "2kVA"}, {"key": "Fuel Tank", "value": "3.6L"}, {"key": "Runtime", "value": "8 hours at 50% load"}, {"key": "Noise Level", "value": "59 dB"}]',
  'day',
  8000,
  2,
  '2025-05-20',
  '2025-11-20',
  true,
  1000,
  'https://www.youtube.com/watch?v=example9',
  'Fuel not included, operation demonstration provided',
  true,
  'strict',
  'Recently serviced and maintained',
  true,
  'active',
  '["https://example.com/images/generator_1.jpg", "https://example.com/images/generator_2.jpg"]'
),

-- Vehicles
(
  'Ather 450X Electric Scooter',
  'Premium electric scooter with 85 km/h top speed and 116 km range. Features touchscreen dashboard and app connectivity.',
  1800,
  'Bangalore, Karnataka',
  'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
  '55555555-5555-5555-5555-555555555555',
  'Ather',
  'Like New',
  '[{"key": "Range", "value": "116 km"}, {"key": "Top Speed", "value": "85 km/h"}, {"key": "Charging Time", "value": "4.5 hours"}, {"key": "Battery", "value": "2.9 kWh"}]',
  'day',
  10000,
  2,
  '2025-06-10',
  '2025-12-10',
  false,
  0,
  'https://www.youtube.com/watch?v=example10',
  'Driving license and Aadhar card required, helmet provided',
  true,
  'strict',
  'Includes charger and mobile app access',
  true,
  'active',
  '["https://example.com/images/ather_1.jpg", "https://example.com/images/ather_2.jpg"]'
),
(
  'Maruti Suzuki Swift',
  'Compact and fuel-efficient hatchback perfect for city driving and short trips. Well-maintained with all safety features.',
  3500,
  'Chennai, Tamil Nadu',
  'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
  '55555555-5555-5555-5555-555555555555',
  'Maruti Suzuki',
  'Good',
  '[{"key": "Fuel Type", "value": "Petrol"}, {"key": "Transmission", "value": "Manual"}, {"key": "Mileage", "value": "22 kmpl"}, {"key": "Seating", "value": "5 Persons"}]',
  'day',
  20000,
  3,
  '2025-05-25',
  '2025-11-25',
  false,
  0,
  'https://www.youtube.com/watch?v=example11',
  'Valid driving license, Aadhar card, and security deposit required',
  true,
  'strict',
  'Fuel not included, to be returned with same fuel level',
  true,
  'active',
  '["https://example.com/images/swift_1.jpg", "https://example.com/images/swift_2.jpg"]'
);
