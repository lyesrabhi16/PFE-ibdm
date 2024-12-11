print("INIT_RS: Start of script");
print("INIT_RS: Initiating replica set");
rs.initiate({
    _id: "rs0",
    members: [
        { _id: 0, host: process.env.HOST_IP+":27018" },
    ],
});
print("INIT_RS: Replica set initiated");
print("INIT_RS: End of script");