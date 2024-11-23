print("INIT_SCRIPT: Start of script");

use("admin");
print("INIT_SCRIPT: Switched to test");
print("INIT_SCRIPT: Authenticating as -> " + process.env.MONGO_INITDB_ROOT_USERNAME);
db.auth(process.env.MONGO_INITDB_ROOT_USERNAME, process.env.MONGO_INITDB_ROOT_PASSWORD)
print("INIT_SCRIPT: Authenticated");

print("INIT_SCRIPT: Creating user -> " + process.env.MONGO_USER);
use(process.env.MONGO_DATABASE)
db.createUser({
    user: process.env.MONGO_USER,
    pwd: process.env.MONGO_PASSWORD,
    roles: [
        {
            role: "readWrite",
            db: process.env.MONGO_DATABASE
        }
    ]
});
print("INIT_SCRIPT: User created");

print("INIT_SCRIPT: End of script");