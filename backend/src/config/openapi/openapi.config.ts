import swaggerJSDoc from "swagger-jsdoc";
import fs from "fs";

export const generateOpenApiSpecification = () => {
    // create openapi specification
    const openapiSpecification = swaggerJSDoc({
        failOnError: true,
        definition: {
            openapi: "3.0.0",
            info: {
                title: "IBDM API",
                version: "1.0.0",
                description: "API for the IBDM project",
            },
        },
        apis: ["./src/routes/**/*.ts", "./src/routes/**/*.js", "./src/routes/**/*.yaml", "./src/routes/**/*.yml", "./src/routes/**/*.json", "./src/routes/**/*.json",],
    });

    // write the openapi specification to a file
    fs.writeFileSync("openapi.json", JSON.stringify(openapiSpecification, null, 2));

    return openapiSpecification;
};

export default generateOpenApiSpecification;