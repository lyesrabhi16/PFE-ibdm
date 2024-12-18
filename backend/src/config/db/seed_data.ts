import { generateHash } from "#utils/generateHash";

export const seed_data = [
    {
        model: "user",
        id: "675ed2ea1164d1a1bae8ab0a",
        data: {
            email: "lyes@test.test",
            password: async () => await generateHash("lyes"),
            name: "Lyes",
        }
    },
    {
        model: "user",
        id: "675ed2ea1164d1a1bae8ab1a",
        data: {
            email: "user1@test.com",
            password: async () => await generateHash("user1"),
            name: "User 1",
        }
    },
    {
        model: "user",
        id: "675ed2ea1164d1a1bae8ab2a",
        data: {
            email: "user2@test.com",
            password: async () => await generateHash("user2"),
            name: "User 2",
        }
    },
    {
        model: "machine",
        id: "675ed2ea1164d1a1bae8ab3a",
        data: {
            name: "Machine 1",
            description: "Machine 1 description",
            site: "site1",
            status: "active",
        }
    },
    {
        model: "machine",
        id: "675ed2ea1164d1a1bae8ab4a",
        data: {
            name: "Machine 2",
            description: "Machine 2 description",
            site: "site2",
            status: "active",
        }
    }
]