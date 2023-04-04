-- database creation --
CREATE DATABASE canal_store;


-- status --
CREATE TABLE status (
    status_id INT PRIMARY KEY IDENTITY,
    status_label VARCHAR(25) NOT NULL,
    status_desc TEXT
);







-- about channel --
CREATE TABLE channel (
    channel_id INT PRIMARY KEY IDENTITY,
    channel_name VARCHAR NOT NULL,
    channel_desc TEXT
);

CREATE TABLE channel_price (
    channel_id INT REFERENCES channel(channel_id),
    channel_price_start_date DATETIME NOT NULL,
    channel_price_end_date DATETIME DEFAULT NULL, -- end
    price MONEY NOT NULL
);
    ALTER TABLE channel_price 
    ADD CONSTRAINT unique_channel_price_start_date 
    UNIQUE(channel_id, channel_price_start_date);

CREATE TABLE channel_status (
    channel_id INT REFERENCES channel(channel_id),
    channel_status_start_date DATETIME NOT NULL,
    channel_status_end_date DATETIME DEFAULT NULL,
    status_id INT REFERENCES status(status_id)
);
    ALTER TABLE channel_status 
    ADD CONSTRAINT unique_channel_status_start_date 
    UNIQUE(channel_id, channel_status_start_date)

CREATE TABLE channel_bundle (
    bundle_id INT REFERENCES bundle(bundle_id),
    channel_id INT REFERENCES channel(channel_id),
    channel_bundle_start_date DATETIME NOT NULL,
    channel_bundle_end_date DATETIME,
    status_id INT REFERENCES status(status_id)
);
    ALTER TABLE channel_bundle
    ADD CONSTRAINT unique_channel_bundle_start_date
    UNIQUE(bundle_id, channel_id, channel_bundle_start_date)
-- channel views --
    -- getting all channels latest price --
    CREATE VIEW channel_latest_price AS
        SELECT channel_id, price, channel_price_start_date, channel_price_end_date 
        FROM channel_price 
        WHERE channel_price_end_date IS NULL
    -- getting all channels latest status --
    CREATE VIEW channel_latest_status AS
        SELECT channel_id, status, channel_price_start_date, channel_price_end_date 
        FROM channel_status 
        WHERE channel_status_end_date IS NULL
    -- getting all channels x price x status --
    CREATE VIEW all_channel AS
        SELECT channel.*, channel_latest_price.price, channel_latest_status.status 
        FROM channel 
        JOIN channel_latest_price ON channel.channel_id = channel_latest_price.channel_id 
            AND channel_latest_price.channel_price_start_date <= NOW()
            AND channel_latest_price.channel_price_end_date IS NULL
        JOIN channel_latest_status ON channel.channel_id = channel_latest_status.channel_id
            AND channel_latest_status.channel_price_start_date <= NOW()
            AND channel_latest_status.channel_price_end_date IS NULL;






-- about bundle --
CREATE TABLE bundle ( -- customized bundle included
    bundle_id INT PRIMARY KEY IDENTITY,
    bundle_name VARCHAR NOT NULL,
    bundle_desc TEXT,
    user_account_id INT REFERENCES user_account(user_account_id) -- bundle creator (the admin for default discounted bundle)
);

CREATE TABLE bundle_discount (
    bundle_id INT REFERENCES bundle(bundle_id),
    bundle_discount_start_date DATETIME NOT NULL,
    bundle_discount_end_date DATETIME DEFAULT NULL,
    discount float DEFAULT 0.
);

CREATE TABLE bundle_status (
    bundle_id INT REFERENCES channel(channel_id),
    bundle_status_start_date DATETIME NOT NULL,
    bundle_status_end_date DATETIME DEFAULT NULL,
    status_id INT REFERENCES status(status_id)
);

-- client side --
CREATE TABLE user_account (
    user_account_id INT PRIMARY KEY IDENTITY,
    user_name VARCHAR NOT NULL,
    first_name VARCHAR NOT NULL,
    email VARCHAR,
    phone_number VARCHAR,
    password VARCHAR,
    status_id INT REFERENCES status(status_id)
);
ALTER TABLE user_account ADD CONSTRAINT email_or_phone_number_not_null
CHECK(email IS NOT NULL OR phone_number IS NOT NULL);







-- location --
CREATE TABLE region (
    region_id INT PRIMARY KEY IDENTITY,
    region_name VARCHAR NOT NULL,
    frequency float DEFAULT 0.
);

CREATE TABLE region_status (
    region_id INT REFERENCES region(region_id),
    region_status_start_date DATETIME NOT NULL,
    region_status_end_date DATETIME,
    status_id INT REFERENCES status(status_id)
);