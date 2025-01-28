print("INIT_RS: Start of script");
print("INIT_RS: Initiating replica set");
try{
    rs.initiate({
        _id: "rs0",
        members: [
            { _id: 0, host: process.env.HOST_IP+":"+process.env.DB_HOST_PORT },
        ],
    });
    print("INIT_RS: Replica set initiated");

}
catch(e){
    print("INIT_RS: Replica set already initiated, reconfiguring");
    
    print("INIT_RS: Replica set Reconfiguring");
    rs.reconfig({
        _id: "rs0",
        members: [
            { _id: 0, host: process.env.HOST_IP+":"+process.env.DB_HOST_PORT },
        ],
    });
    print("INIT_RS: Replica set Reconfigured");
}

print("INIT_RS: End of script");