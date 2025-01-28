import generateOpenApiSpecification from "#config/openapi/openapi.config";
import { Router } from "express";
import swaggerUi from "swagger-ui-express";

const router = Router();

const openapiSpecification = generateOpenApiSpecification();


/**
 * @openapi
 * tags:
 *      name: Documentation
 *      description: Documentation routes
 * 
 */

/**
 * @openapi
 * 
 * /api/documentation/openapi.json:
 *  get:
 *   operationId: getOpenApiSpecificationJson
 *   summary: Get the OpenAPI specification in json format
 *   tags: [Documentation]
 *   description: Get the OpenAPI specification
 *   responses:
 *      200:
 *          description: OpenAPI specification
 *          content:
 *              application/json:
 *                  schema:
 *                      type: object
 */
router.get("/openapi.json", (req, res) => {
  res.json(openapiSpecification);
});


/**
 * @openapi
 * /api/documentation:
 *  get:
 *      operationId: getDocumentationUi
 *      summary: Get the Swagger UI
 *      tags: [Documentation]
 *      responses:
 *          200:
 *              description: Swagger UI page
 *              content:
 *                  text/html:
 *                     schema:
 *                        type: string
 *                        example: "<!DOCTYPE html>..."
 */
router.use("/", swaggerUi.serve, swaggerUi.setup(openapiSpecification));

export default router;
