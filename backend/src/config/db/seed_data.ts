import { generateHash } from "#utils/generateHash";
import { $Enums } from "@prisma/client";

export const seed_data = {
    ibdm: [
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab0a",
            data: {
                email: "lyes@test.test",
                password: async () => await generateHash("lyes"),
                name: "Lyes",
                role: "ADMIN_SYSTEM",
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab1a",
            data: {
                email: "djamel@test.com",
                password: async () => await generateHash("djamel"),
                name: "djamel",
                role: $Enums.Role.ADMIN,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab2a",
            data: {
                email: "lynda@test.com",
                password: async () => await generateHash("lynda"),
                name: "lynda",
                role: $Enums.Role.ADMIN,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab3a",
            data: {
                email: "sup3@test.com",
                password: async () => await generateHash("sup3"),
                name: "sup 3",
                role: $Enums.Role.SUPERVISOR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab4a",
            data: {
                email: "sup4@test.com",
                password: async () => await generateHash("sup4"),
                name: "sup 4",
                role: $Enums.Role.SUPERVISOR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab5a",
            data: {
                email: "op5@test.com",
                password: async () => await generateHash("op5"),
                name: "op 5",
                role: $Enums.Role.OPERATEUR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab6a",
            data: {
                email: "op66@test.com",
                password: async () => await generateHash("op66"),
                name: "op6 6",
                role: $Enums.Role.OPERATEUR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab7a",
            data: {
                email: "op7@test.com",
                password: async () => await generateHash("op7"),
                name: "op 7",
                role: $Enums.Role.OPERATEUR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab8a",
            data: {
                email: "op8@test.com",
                password: async () => await generateHash("op8"),
                name: "op 8",
                role: $Enums.Role.OPERATEUR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab9a",
            data: {
                email: "op9@test.com",
                password: async () => await generateHash("op9"),
                name: "op 9",
                role: $Enums.Role.OPERATEUR,
            }
        },
        {
            model: "user",
            id: "675ed2ea1164d1a1bae8ab1b",
            data: {
                email: "op10@test.com",
                password: async () => await generateHash("op10"),
                name: "op 10",
                role: $Enums.Role.OPERATEUR,
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
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab1a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab0a", //lyes
                subordinate_id: "675ed2ea1164d1a1bae8ab1a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab2a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab0a", //lyes
                subordinate_id: "675ed2ea1164d1a1bae8ab2a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab3a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab2a",
                subordinate_id: "675ed2ea1164d1a1bae8ab3a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab2a",
                subordinate_id: "675ed2ea1164d1a1bae8ab4a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a", 
                subordinate_id: "675ed2ea1164d1a1bae8ab5a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a", 
                subordinate_id: "675ed2ea1164d1a1bae8ab6a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a",
                subordinate_id: "675ed2ea1164d1a1bae8ab7a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a", 
                subordinate_id: "675ed2ea1164d1a1bae8ab8a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a", 
                subordinate_id: "675ed2ea1164d1a1bae8ab9a",
            }
        },
        {
            model: "SuperiorAndSubordinate",
            id: "775ed2ea1164d1a1bae8ab4a",
            data: {
                superior_id: "675ed2ea1164d1a1bae8ab4a", 
                subordinate_id: "675ed2ea1164d1a1bae8ab1b",
            }
        },
    ],
    automate: [
        {
            model: "test_table",
            data: {
                test_table_str: "hi",
            }
        }
    ],


}