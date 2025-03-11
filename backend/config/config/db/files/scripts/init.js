print("***********************************")
print("************ INIT SCRIPT ***********")
print("***********************************")

use("admin");

    print("Creating admin user: " + process.env.MONGO_ADMIN_USER)
    db.createUser({
        user: process.env.MONGO_ADMIN_USER,
        pwd: process.env.MONGO_ADMIN_PASS,
        roles: [
            "userAdminAnyDatabase",            
            "readWriteAnyDatabase",
            "dbAdminAnyDatabase",
            "clusterAdmin"
        ]
    });
    print("Admin user created")
print("Authenticating using MONGO_ADMIN_USER and MONGO_ADMIN_PASS env variables...", process.env.MONGO_ADMIN_USER)
db.auth(process.env.MONGO_ADMIN_USER, process.env.MONGO_ADMIN_PASS)
print("Authenticated")

print("Creating Users For DB: ", process.env.MONGO_DB)
use(process.env.MONGO_DB)
print("users_to_create string: ", process.env.MONGO_USERS.replaceAll(" ", ''))
let users_to_create = process.env.MONGO_USERS? JSON.parse(process.env.MONGO_USERS): []
let existing_users = db.getUsers().users || []
if (users_to_create.length == 0) {
    print("No users to create")
}else{
    users_to_create.forEach(user => {
        print("User: ", user.user)
        if ( existing_users.find(u => u.user == user.user) ) {
            print("User already exists: ", user.user)
            return
        }
        else{
            print("creating...")
            db.createUser({
                user: user.user,
                pwd: user.pwd,
                roles: [
                    {
                        role: "readWrite",
                        db: process.env.MONGO_DB
                    }
                ]})
            print("User created: ", user.user)
        }
    });
}

print("***********************************")
print("********** END INIT SCRIPT ********")
print("***********************************")