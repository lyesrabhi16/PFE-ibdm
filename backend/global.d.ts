declare namespace Express {
    export interface Request {
        user? : {
            id: string;
            email: string;
        };
        pagination: typeof import("#config/pagination/pagination.config").paginationConfig;
    }
    
}