import { db_client } from "#config/db/db";
import { seed_data as sd } from "#config/db/seed_data";

const seed = async (seed_data: typeof sd) => {
    return new Promise(async (resolve, reject) => {
        console.log("Connecting to database...");
        await db_client.$connect().catch((err: Error) => {
            console.log("Error connecting to database", err);
            reject(err);
        });

        console.log("Clearing database...");
        await db_client.user.deleteMany({}).catch((err: Error) => {
            console.log("Error clearing user table", err);
            reject(err);
        });
        await db_client.machine.deleteMany({}).catch((err: Error) => {
            console.log("Error clearing machine table", err);
            reject(err);
        });
        
        console.log("Seeding database...");
        for (const data of seed_data) {
            await (db_client as any)[`${data.model}`].upsert({
                where: { id: data.id },
                update: {},
                create: {
                    id: data.id,
                    ...data.data,
                    password: data.data.password ? await data.data.password(): undefined
                }
            }).catch((err: Error) => {
                console.log(`Error seeding ${data.model} with ${data.data.name || data.id}`, err);

                reject(err);
            })
            console.log(`Seeded ${data.model} with ${data.data.name || data.id}`);

        }
        resolve("Database seeded");
    })
}


console.log("Seed starting");

seed(sd).then((res) => {

    console.log("Seed completed", res);
    db_client.$disconnect();
}).catch((err) => {
    console.log("Seed failed", err);

    db_client.$disconnect();
});

export default seed;