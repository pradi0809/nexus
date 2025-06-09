-- Initialize Nexus database
-- This script runs automatically when PostgreSQL container starts

-- Create extensions if needed
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Set proper permissions
GRANT ALL PRIVILEGES ON DATABASE nexus TO nexus;

-- Optional: Create additional schemas if needed for multi-tenancy
-- CREATE SCHEMA IF NOT EXISTS nexus_config AUTHORIZATION nexus;
-- CREATE SCHEMA IF NOT EXISTS nexus_security AUTHORIZATION nexus;