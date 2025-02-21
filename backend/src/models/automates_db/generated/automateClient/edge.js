
Object.defineProperty(exports, "__esModule", { value: true });

const {
  PrismaClientKnownRequestError,
  PrismaClientUnknownRequestError,
  PrismaClientRustPanicError,
  PrismaClientInitializationError,
  PrismaClientValidationError,
  NotFoundError,
  getPrismaClient,
  sqltag,
  empty,
  join,
  raw,
  skip,
  Decimal,
  Debug,
  objectEnumValues,
  makeStrictEnum,
  Extensions,
  warnOnce,
  defineDmmfProperty,
  Public,
  getRuntime
} = require('./runtime/edge.js')


const Prisma = {}

exports.Prisma = Prisma
exports.$Enums = {}

/**
 * Prisma Client JS version: 5.22.0
 * Query Engine version: 4123509d24aa4dede1e864b46351bf2790323b69
 */
Prisma.prismaVersion = {
  client: "5.22.0",
  engine: "4123509d24aa4dede1e864b46351bf2790323b69"
}

Prisma.PrismaClientKnownRequestError = PrismaClientKnownRequestError;
Prisma.PrismaClientUnknownRequestError = PrismaClientUnknownRequestError
Prisma.PrismaClientRustPanicError = PrismaClientRustPanicError
Prisma.PrismaClientInitializationError = PrismaClientInitializationError
Prisma.PrismaClientValidationError = PrismaClientValidationError
Prisma.NotFoundError = NotFoundError
Prisma.Decimal = Decimal

/**
 * Re-export of sql-template-tag
 */
Prisma.sql = sqltag
Prisma.empty = empty
Prisma.join = join
Prisma.raw = raw
Prisma.validator = Public.validator

/**
* Extensions
*/
Prisma.getExtensionContext = Extensions.getExtensionContext
Prisma.defineExtension = Extensions.defineExtension

/**
 * Shorthand utilities for JSON filtering
 */
Prisma.DbNull = objectEnumValues.instances.DbNull
Prisma.JsonNull = objectEnumValues.instances.JsonNull
Prisma.AnyNull = objectEnumValues.instances.AnyNull

Prisma.NullTypes = {
  DbNull: objectEnumValues.classes.DbNull,
  JsonNull: objectEnumValues.classes.JsonNull,
  AnyNull: objectEnumValues.classes.AnyNull
}





/**
 * Enums
 */
exports.Prisma.TransactionIsolationLevel = makeStrictEnum({
  ReadUncommitted: 'ReadUncommitted',
  ReadCommitted: 'ReadCommitted',
  RepeatableRead: 'RepeatableRead',
  Serializable: 'Serializable',
  Snapshot: 'Snapshot'
});

exports.Prisma.Table_dateScalarFieldEnum = {
  id: 'id',
  date: 'date'
};

exports.Prisma.Test_tableScalarFieldEnum = {
  id: 'id',
  test_table_str: 'test_table_str'
};

exports.Prisma.SortOrder = {
  asc: 'asc',
  desc: 'desc'
};

exports.Prisma.NullsOrder = {
  first: 'first',
  last: 'last'
};


exports.Prisma.ModelName = {
  Table_date: 'Table_date',
  test_table: 'test_table'
};
/**
 * Create the Client
 */
const config = {
  "generator": {
    "name": "automateClient",
    "provider": {
      "fromEnvVar": null,
      "value": "prisma-client-js"
    },
    "output": {
      "value": "C:\\Users\\CE PC\\PFE-ibdm\\backend\\src\\models\\automates_db\\generated\\automateClient",
      "fromEnvVar": null
    },
    "config": {
      "engineType": "library"
    },
    "binaryTargets": [
      {
        "fromEnvVar": null,
        "value": "windows",
        "native": true
      },
      {
        "fromEnvVar": null,
        "value": "debian-openssl-3.0.x"
      }
    ],
    "previewFeatures": [],
    "sourceFilePath": "C:\\Users\\CE PC\\PFE-ibdm\\backend\\src\\models\\automates_db\\schema.prisma",
    "isCustomOutput": true
  },
  "relativeEnvPaths": {
    "rootEnvPath": null,
    "schemaEnvPath": "../../../../../.env"
  },
  "relativePath": "../..",
  "clientVersion": "5.22.0",
  "engineVersion": "4123509d24aa4dede1e864b46351bf2790323b69",
  "datasourceNames": [
    "automate_db"
  ],
  "activeProvider": "sqlserver",
  "inlineDatasources": {
    "automate_db": {
      "url": {
        "fromEnvVar": "SQLSERVER_DATABASE_URL",
        "value": null
      }
    }
  },
  "inlineSchema": "generator automateClient {\n  provider      = \"prisma-client-js\"\n  output        = \"./generated/automateClient\"\n  binaryTargets = [\"native\", \"debian-openssl-3.0.x\"]\n}\n\ndatasource automate_db {\n  provider = \"sqlserver\"\n  url      = env(\"SQLSERVER_DATABASE_URL\")\n}\n\nmodel Table_date {\n  id   Int       @id(map: \"PK_table_date\") @default(dbgenerated()) @automate_db.Int\n  date DateTime?\n}\n\nmodel test_table {\n  id             Int     @id(map: \"PK_test_table\") @default(autoincrement()) @automate_db.Int\n  test_table_str String? @automate_db.NChar(10)\n}\n",
  "inlineSchemaHash": "ed8a21a5e9f64fa592529bf65661054ff7bff48bbae7fec65d7b1ee93ae286bf",
  "copyEngine": true
}
config.dirname = '/'

config.runtimeDataModel = JSON.parse("{\"models\":{\"Table_date\":{\"dbName\":null,\"schema\":null,\"fields\":[{\"name\":\"id\",\"kind\":\"scalar\",\"isList\":false,\"isRequired\":true,\"isUnique\":false,\"isId\":true,\"isReadOnly\":false,\"hasDefaultValue\":true,\"type\":\"Int\",\"nativeType\":[\"Int\",[]],\"default\":{\"name\":\"dbgenerated\",\"args\":[]},\"isGenerated\":false,\"isUpdatedAt\":false},{\"name\":\"date\",\"kind\":\"scalar\",\"isList\":false,\"isRequired\":false,\"isUnique\":false,\"isId\":false,\"isReadOnly\":false,\"hasDefaultValue\":false,\"type\":\"DateTime\",\"nativeType\":null,\"isGenerated\":false,\"isUpdatedAt\":false}],\"primaryKey\":null,\"uniqueFields\":[],\"uniqueIndexes\":[],\"isGenerated\":false},\"test_table\":{\"dbName\":null,\"schema\":null,\"fields\":[{\"name\":\"id\",\"kind\":\"scalar\",\"isList\":false,\"isRequired\":true,\"isUnique\":false,\"isId\":true,\"isReadOnly\":false,\"hasDefaultValue\":true,\"type\":\"Int\",\"nativeType\":[\"Int\",[]],\"default\":{\"name\":\"autoincrement\",\"args\":[]},\"isGenerated\":false,\"isUpdatedAt\":false},{\"name\":\"test_table_str\",\"kind\":\"scalar\",\"isList\":false,\"isRequired\":false,\"isUnique\":false,\"isId\":false,\"isReadOnly\":false,\"hasDefaultValue\":false,\"type\":\"String\",\"nativeType\":[\"NChar\",[\"10\"]],\"isGenerated\":false,\"isUpdatedAt\":false}],\"primaryKey\":null,\"uniqueFields\":[],\"uniqueIndexes\":[],\"isGenerated\":false}},\"enums\":{},\"types\":{}}")
defineDmmfProperty(exports.Prisma, config.runtimeDataModel)
config.engineWasm = undefined

config.injectableEdgeEnv = () => ({
  parsed: {
    SQLSERVER_DATABASE_URL: typeof globalThis !== 'undefined' && globalThis['SQLSERVER_DATABASE_URL'] || typeof process !== 'undefined' && process.env && process.env.SQLSERVER_DATABASE_URL || undefined
  }
})

if (typeof globalThis !== 'undefined' && globalThis['DEBUG'] || typeof process !== 'undefined' && process.env && process.env.DEBUG || undefined) {
  Debug.enable(typeof globalThis !== 'undefined' && globalThis['DEBUG'] || typeof process !== 'undefined' && process.env && process.env.DEBUG || undefined)
}

const PrismaClient = getPrismaClient(config)
exports.PrismaClient = PrismaClient
Object.assign(exports, Prisma)

