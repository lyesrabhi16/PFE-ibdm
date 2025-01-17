declare namespace Express {
    export interface Request {
        user? : {
            id: string;
            email: string;
            role: import("@prisma/client").$Enums.Role;
        };
        pagination: typeof import("#config/pagination/pagination.config").paginationConfig;
    }
    
}