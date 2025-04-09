INSERT INTO position (position_name)
VALUES ('Админ')
ON CONFLICT (position_name) DO NOTHING;

INSERT INTO users (
    first_name, last_name, phone, email, user_login, user_password, position_id, created_at
) VALUES (
    'Admin',                    
    'Adminov',                  
    '0000000000',               
    'admin@example.com',        
    'admin',                    
    '1',                        
    (SELECT position_id FROM position WHERE position_name = 'Админ'),
    CURRENT_TIMESTAMP
);
