import { db_client } from "#config/db/db";
import { seed_data as sd } from "#config/db/seed_data";

const seed = async (seed_data: typeof sd) => {
    return new Promise(async (resolve, reject) => {
        console.log("Connecting to database...");
        await db_client.ibdm.$connect().catch((err: Error) => {
            console.log("Error connecting to database", err);
            reject(err);
        });

        console.log("Clearing database...");
        await db_client.ibdm.user.deleteMany({}).catch((err: Error) => {
            console.log("Error clearing user table", err);
            reject(err);
        });
        await db_client.ibdm.machine.deleteMany({}).catch((err: Error) => {
            console.log("Error clearing machine table", err);
            reject(err);
        });
        
        console.log("Seeding database...");

        const execute = async (db:any, data:any) => {
            if (db === "ibdm"){
                return await (db_client.ibdm as any)[`${data.model}`].upsert({
                    where: {id: data.id},
                    update: {},
                    create: {
                        id: data.id,
                        ...data.data,
                        password: data.data.password ? await data.data.password(): undefined
                    }
                });
            }
            else if (db === "automate"){
                return await (db_client.automate as any)[`${data.model}`].create({
                    data: {
                        id: data.id,
                        ...data.data,
                        password: data.data.password ? await data.data.password(): undefined
                    }
                })
            }
        }

        for (const db in seed_data) {

            for (const data of (seed_data as any)[db]) {


                const res = await execute(db, data).catch((err: Error) => {
                    console.log(`Error seeding ${data.model} with ${data.data.name || data.id}`, err);
    
                    reject(err);
                })
                console.log(`Seeded ${data.model} with ${data.data.name || data.id || res.id}`);
    
            }
        }
        
        resolve("Database seeded");
    })
}


console.log("Seed starting");

seed(sd).then((res) => {

    console.log("Seed completed", res);
    db_client.ibdm.$disconnect();
}).catch((err) => {
    console.log("Seed failed", err);

    db_client.ibdm.$disconnect();
});

export default seed;