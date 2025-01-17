
/**
 * Client
**/

import * as runtime from './runtime/library.js';
import $Types = runtime.Types // general types
import $Public = runtime.Types.Public
import $Utils = runtime.Types.Utils
import $Extensions = runtime.Types.Extensions
import $Result = runtime.Types.Result

export type PrismaPromise<T> = $Public.PrismaPromise<T>


/**
 * Model Table_date
 * 
 */
export type Table_date = $Result.DefaultSelection<Prisma.$Table_datePayload>
/**
 * Model test_table
 * 
 */
export type test_table = $Result.DefaultSelection<Prisma.$test_tablePayload>

/**
 * ##  Prisma Client ʲˢ
 *
 * Type-safe database client for TypeScript & Node.js
 * @example
 * ```
 * const prisma = new PrismaClient()
 * // Fetch zero or more Table_dates
 * const table_dates = await prisma.table_date.findMany()
 * ```
 *
 *
 * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client).
 */
export class PrismaClient<
  ClientOptions extends Prisma.PrismaClientOptions = Prisma.PrismaClientOptions,
  U = 'log' extends keyof ClientOptions ? ClientOptions['log'] extends Array<Prisma.LogLevel | Prisma.LogDefinition> ? Prisma.GetEvents<ClientOptions['log']> : never : never,
  ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs
> {
  [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['other'] }

    /**
   * ##  Prisma Client ʲˢ
   *
   * Type-safe database client for TypeScript & Node.js
   * @example
   * ```
   * const prisma = new PrismaClient()
   * // Fetch zero or more Table_dates
   * const table_dates = await prisma.table_date.findMany()
   * ```
   *
   *
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client).
   */

  constructor(optionsArg ?: Prisma.Subset<ClientOptions, Prisma.PrismaClientOptions>);
  $on<V extends U>(eventType: V, callback: (event: V extends 'query' ? Prisma.QueryEvent : Prisma.LogEvent) => void): void;

  /**
   * Connect with the database
   */
  $connect(): $Utils.JsPromise<void>;

  /**
   * Disconnect from the database
   */
  $disconnect(): $Utils.JsPromise<void>;

  /**
   * Add a middleware
   * @deprecated since 4.16.0. For new code, prefer client extensions instead.
   * @see https://pris.ly/d/extensions
   */
  $use(cb: Prisma.Middleware): void

/**
   * Executes a prepared raw query and returns the number of affected rows.
   * @example
   * ```
   * const result = await prisma.$executeRaw`UPDATE User SET cool = ${true} WHERE email = ${'user@email.com'};`
   * ```
   *
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $executeRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Executes a raw query and returns the number of affected rows.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$executeRawUnsafe('UPDATE User SET cool = $1 WHERE email = $2 ;', true, 'user@email.com')
   * ```
   *
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $executeRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<number>;

  /**
   * Performs a prepared raw query and returns the `SELECT` data.
   * @example
   * ```
   * const result = await prisma.$queryRaw`SELECT * FROM User WHERE id = ${1} OR email = ${'user@email.com'};`
   * ```
   *
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $queryRaw<T = unknown>(query: TemplateStringsArray | Prisma.Sql, ...values: any[]): Prisma.PrismaPromise<T>;

  /**
   * Performs a raw query and returns the `SELECT` data.
   * Susceptible to SQL injections, see documentation.
   * @example
   * ```
   * const result = await prisma.$queryRawUnsafe('SELECT * FROM User WHERE id = $1 OR email = $2;', 1, 'user@email.com')
   * ```
   *
   * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/raw-database-access).
   */
  $queryRawUnsafe<T = unknown>(query: string, ...values: any[]): Prisma.PrismaPromise<T>;


  /**
   * Allows the running of a sequence of read/write operations that are guaranteed to either succeed or fail as a whole.
   * @example
   * ```
   * const [george, bob, alice] = await prisma.$transaction([
   *   prisma.user.create({ data: { name: 'George' } }),
   *   prisma.user.create({ data: { name: 'Bob' } }),
   *   prisma.user.create({ data: { name: 'Alice' } }),
   * ])
   * ```
   * 
   * Read more in our [docs](https://www.prisma.io/docs/concepts/components/prisma-client/transactions).
   */
  $transaction<P extends Prisma.PrismaPromise<any>[]>(arg: [...P], options?: { isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<runtime.Types.Utils.UnwrapTuple<P>>

  $transaction<R>(fn: (prisma: Omit<PrismaClient, runtime.ITXClientDenyList>) => $Utils.JsPromise<R>, options?: { maxWait?: number, timeout?: number, isolationLevel?: Prisma.TransactionIsolationLevel }): $Utils.JsPromise<R>


  $extends: $Extensions.ExtendsHook<"extends", Prisma.TypeMapCb, ExtArgs, $Utils.Call<Prisma.TypeMapCb, {
    extArgs: ExtArgs
  }>, ClientOptions>

      /**
   * `prisma.table_date`: Exposes CRUD operations for the **Table_date** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more Table_dates
    * const table_dates = await prisma.table_date.findMany()
    * ```
    */
  get table_date(): Prisma.Table_dateDelegate<ExtArgs, ClientOptions>;

  /**
   * `prisma.test_table`: Exposes CRUD operations for the **test_table** model.
    * Example usage:
    * ```ts
    * // Fetch zero or more Test_tables
    * const test_tables = await prisma.test_table.findMany()
    * ```
    */
  get test_table(): Prisma.test_tableDelegate<ExtArgs, ClientOptions>;
}

export namespace Prisma {
  export import DMMF = runtime.DMMF

  export type PrismaPromise<T> = $Public.PrismaPromise<T>

  /**
   * Validator
   */
  export import validator = runtime.Public.validator

  /**
   * Prisma Errors
   */
  export import PrismaClientKnownRequestError = runtime.PrismaClientKnownRequestError
  export import PrismaClientUnknownRequestError = runtime.PrismaClientUnknownRequestError
  export import PrismaClientRustPanicError = runtime.PrismaClientRustPanicError
  export import PrismaClientInitializationError = runtime.PrismaClientInitializationError
  export import PrismaClientValidationError = runtime.PrismaClientValidationError

  /**
   * Re-export of sql-template-tag
   */
  export import sql = runtime.sqltag
  export import empty = runtime.empty
  export import join = runtime.join
  export import raw = runtime.raw
  export import Sql = runtime.Sql



  /**
   * Decimal.js
   */
  export import Decimal = runtime.Decimal

  export type DecimalJsLike = runtime.DecimalJsLike

  /**
   * Metrics 
   */
  export type Metrics = runtime.Metrics
  export type Metric<T> = runtime.Metric<T>
  export type MetricHistogram = runtime.MetricHistogram
  export type MetricHistogramBucket = runtime.MetricHistogramBucket

  /**
  * Extensions
  */
  export import Extension = $Extensions.UserArgs
  export import getExtensionContext = runtime.Extensions.getExtensionContext
  export import Args = $Public.Args
  export import Payload = $Public.Payload
  export import Result = $Public.Result
  export import Exact = $Public.Exact

  /**
   * Prisma Client JS version: 6.2.1
   * Query Engine version: 4123509d24aa4dede1e864b46351bf2790323b69
   */
  export type PrismaVersion = {
    client: string
  }

  export const prismaVersion: PrismaVersion 

  /**
   * Utility Types
   */


  export import JsonObject = runtime.JsonObject
  export import JsonArray = runtime.JsonArray
  export import JsonValue = runtime.JsonValue
  export import InputJsonObject = runtime.InputJsonObject
  export import InputJsonArray = runtime.InputJsonArray
  export import InputJsonValue = runtime.InputJsonValue

  /**
   * Types of the values used to represent different kinds of `null` values when working with JSON fields.
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  namespace NullTypes {
    /**
    * Type of `Prisma.DbNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.DbNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class DbNull {
      private DbNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.JsonNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.JsonNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class JsonNull {
      private JsonNull: never
      private constructor()
    }

    /**
    * Type of `Prisma.AnyNull`.
    * 
    * You cannot use other instances of this class. Please use the `Prisma.AnyNull` value.
    * 
    * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
    */
    class AnyNull {
      private AnyNull: never
      private constructor()
    }
  }

  /**
   * Helper for filtering JSON entries that have `null` on the database (empty on the db)
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const DbNull: NullTypes.DbNull

  /**
   * Helper for filtering JSON entries that have JSON `null` values (not empty on the db)
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const JsonNull: NullTypes.JsonNull

  /**
   * Helper for filtering JSON entries that are `Prisma.DbNull` or `Prisma.JsonNull`
   * 
   * @see https://www.prisma.io/docs/concepts/components/prisma-client/working-with-fields/working-with-json-fields#filtering-on-a-json-field
   */
  export const AnyNull: NullTypes.AnyNull

  type SelectAndInclude = {
    select: any
    include: any
  }

  type SelectAndOmit = {
    select: any
    omit: any
  }

  /**
   * Get the type of the value, that the Promise holds.
   */
  export type PromiseType<T extends PromiseLike<any>> = T extends PromiseLike<infer U> ? U : T;

  /**
   * Get the return type of a function which returns a Promise.
   */
  export type PromiseReturnType<T extends (...args: any) => $Utils.JsPromise<any>> = PromiseType<ReturnType<T>>

  /**
   * From T, pick a set of properties whose keys are in the union K
   */
  type Prisma__Pick<T, K extends keyof T> = {
      [P in K]: T[P];
  };


  export type Enumerable<T> = T | Array<T>;

  export type RequiredKeys<T> = {
    [K in keyof T]-?: {} extends Prisma__Pick<T, K> ? never : K
  }[keyof T]

  export type TruthyKeys<T> = keyof {
    [K in keyof T as T[K] extends false | undefined | null ? never : K]: K
  }

  export type TrueKeys<T> = TruthyKeys<Prisma__Pick<T, RequiredKeys<T>>>

  /**
   * Subset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection
   */
  export type Subset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never;
  };

  /**
   * SelectSubset
   * @desc From `T` pick properties that exist in `U`. Simple version of Intersection.
   * Additionally, it validates, if both select and include are present. If the case, it errors.
   */
  export type SelectSubset<T, U> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    (T extends SelectAndInclude
      ? 'Please either choose `select` or `include`.'
      : T extends SelectAndOmit
        ? 'Please either choose `select` or `omit`.'
        : {})

  /**
   * Subset + Intersection
   * @desc From `T` pick properties that exist in `U` and intersect `K`
   */
  export type SubsetIntersection<T, U, K> = {
    [key in keyof T]: key extends keyof U ? T[key] : never
  } &
    K

  type Without<T, U> = { [P in Exclude<keyof T, keyof U>]?: never };

  /**
   * XOR is needed to have a real mutually exclusive union type
   * https://stackoverflow.com/questions/42123407/does-typescript-support-mutually-exclusive-types
   */
  type XOR<T, U> =
    T extends object ?
    U extends object ?
      (Without<T, U> & U) | (Without<U, T> & T)
    : U : T


  /**
   * Is T a Record?
   */
  type IsObject<T extends any> = T extends Array<any>
  ? False
  : T extends Date
  ? False
  : T extends Uint8Array
  ? False
  : T extends BigInt
  ? False
  : T extends object
  ? True
  : False


  /**
   * If it's T[], return T
   */
  export type UnEnumerate<T extends unknown> = T extends Array<infer U> ? U : T

  /**
   * From ts-toolbelt
   */

  type __Either<O extends object, K extends Key> = Omit<O, K> &
    {
      // Merge all but K
      [P in K]: Prisma__Pick<O, P & keyof O> // With K possibilities
    }[K]

  type EitherStrict<O extends object, K extends Key> = Strict<__Either<O, K>>

  type EitherLoose<O extends object, K extends Key> = ComputeRaw<__Either<O, K>>

  type _Either<
    O extends object,
    K extends Key,
    strict extends Boolean
  > = {
    1: EitherStrict<O, K>
    0: EitherLoose<O, K>
  }[strict]

  type Either<
    O extends object,
    K extends Key,
    strict extends Boolean = 1
  > = O extends unknown ? _Either<O, K, strict> : never

  export type Union = any

  type PatchUndefined<O extends object, O1 extends object> = {
    [K in keyof O]: O[K] extends undefined ? At<O1, K> : O[K]
  } & {}

  /** Helper Types for "Merge" **/
  export type IntersectOf<U extends Union> = (
    U extends unknown ? (k: U) => void : never
  ) extends (k: infer I) => void
    ? I
    : never

  export type Overwrite<O extends object, O1 extends object> = {
      [K in keyof O]: K extends keyof O1 ? O1[K] : O[K];
  } & {};

  type _Merge<U extends object> = IntersectOf<Overwrite<U, {
      [K in keyof U]-?: At<U, K>;
  }>>;

  type Key = string | number | symbol;
  type AtBasic<O extends object, K extends Key> = K extends keyof O ? O[K] : never;
  type AtStrict<O extends object, K extends Key> = O[K & keyof O];
  type AtLoose<O extends object, K extends Key> = O extends unknown ? AtStrict<O, K> : never;
  export type At<O extends object, K extends Key, strict extends Boolean = 1> = {
      1: AtStrict<O, K>;
      0: AtLoose<O, K>;
  }[strict];

  export type ComputeRaw<A extends any> = A extends Function ? A : {
    [K in keyof A]: A[K];
  } & {};

  export type OptionalFlat<O> = {
    [K in keyof O]?: O[K];
  } & {};

  type _Record<K extends keyof any, T> = {
    [P in K]: T;
  };

  // cause typescript not to expand types and preserve names
  type NoExpand<T> = T extends unknown ? T : never;

  // this type assumes the passed object is entirely optional
  type AtLeast<O extends object, K extends string> = NoExpand<
    O extends unknown
    ? | (K extends keyof O ? { [P in K]: O[P] } & O : O)
      | {[P in keyof O as P extends K ? K : never]-?: O[P]} & O
    : never>;

  type _Strict<U, _U = U> = U extends unknown ? U & OptionalFlat<_Record<Exclude<Keys<_U>, keyof U>, never>> : never;

  export type Strict<U extends object> = ComputeRaw<_Strict<U>>;
  /** End Helper Types for "Merge" **/

  export type Merge<U extends object> = ComputeRaw<_Merge<Strict<U>>>;

  /**
  A [[Boolean]]
  */
  export type Boolean = True | False

  // /**
  // 1
  // */
  export type True = 1

  /**
  0
  */
  export type False = 0

  export type Not<B extends Boolean> = {
    0: 1
    1: 0
  }[B]

  export type Extends<A1 extends any, A2 extends any> = [A1] extends [never]
    ? 0 // anything `never` is false
    : A1 extends A2
    ? 1
    : 0

  export type Has<U extends Union, U1 extends Union> = Not<
    Extends<Exclude<U1, U>, U1>
  >

  export type Or<B1 extends Boolean, B2 extends Boolean> = {
    0: {
      0: 0
      1: 1
    }
    1: {
      0: 1
      1: 1
    }
  }[B1][B2]

  export type Keys<U extends Union> = U extends unknown ? keyof U : never

  type Cast<A, B> = A extends B ? A : B;

  export const type: unique symbol;



  /**
   * Used by group by
   */

  export type GetScalarType<T, O> = O extends object ? {
    [P in keyof T]: P extends keyof O
      ? O[P]
      : never
  } : never

  type FieldPaths<
    T,
    U = Omit<T, '_avg' | '_sum' | '_count' | '_min' | '_max'>
  > = IsObject<T> extends True ? U : T

  type GetHavingFields<T> = {
    [K in keyof T]: Or<
      Or<Extends<'OR', K>, Extends<'AND', K>>,
      Extends<'NOT', K>
    > extends True
      ? // infer is only needed to not hit TS limit
        // based on the brilliant idea of Pierre-Antoine Mills
        // https://github.com/microsoft/TypeScript/issues/30188#issuecomment-478938437
        T[K] extends infer TK
        ? GetHavingFields<UnEnumerate<TK> extends object ? Merge<UnEnumerate<TK>> : never>
        : never
      : {} extends FieldPaths<T[K]>
      ? never
      : K
  }[keyof T]

  /**
   * Convert tuple to union
   */
  type _TupleToUnion<T> = T extends (infer E)[] ? E : never
  type TupleToUnion<K extends readonly any[]> = _TupleToUnion<K>
  type MaybeTupleToUnion<T> = T extends any[] ? TupleToUnion<T> : T

  /**
   * Like `Pick`, but additionally can also accept an array of keys
   */
  type PickEnumerable<T, K extends Enumerable<keyof T> | keyof T> = Prisma__Pick<T, MaybeTupleToUnion<K>>

  /**
   * Exclude all keys with underscores
   */
  type ExcludeUnderscoreKeys<T extends string> = T extends `_${string}` ? never : T


  export type FieldRef<Model, FieldType> = runtime.FieldRef<Model, FieldType>

  type FieldRefInputType<Model, FieldType> = Model extends never ? never : FieldRef<Model, FieldType>


  export const ModelName: {
    Table_date: 'Table_date',
    test_table: 'test_table'
  };

  export type ModelName = (typeof ModelName)[keyof typeof ModelName]


  export type Datasources = {
    automate_db?: Datasource
  }

  interface TypeMapCb extends $Utils.Fn<{extArgs: $Extensions.InternalArgs, clientOptions: PrismaClientOptions }, $Utils.Record<string, any>> {
    returns: Prisma.TypeMap<this['params']['extArgs'], this['params']['clientOptions']>
  }

  export type TypeMap<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> = {
    meta: {
      modelProps: "table_date" | "test_table"
      txIsolationLevel: Prisma.TransactionIsolationLevel
    }
    model: {
      Table_date: {
        payload: Prisma.$Table_datePayload<ExtArgs>
        fields: Prisma.Table_dateFieldRefs
        operations: {
          findUnique: {
            args: Prisma.Table_dateFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.Table_dateFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          findFirst: {
            args: Prisma.Table_dateFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.Table_dateFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          findMany: {
            args: Prisma.Table_dateFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>[]
          }
          create: {
            args: Prisma.Table_dateCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          createMany: {
            args: Prisma.Table_dateCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.Table_dateDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          update: {
            args: Prisma.Table_dateUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          deleteMany: {
            args: Prisma.Table_dateDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.Table_dateUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.Table_dateUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$Table_datePayload>
          }
          aggregate: {
            args: Prisma.Table_dateAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateTable_date>
          }
          groupBy: {
            args: Prisma.Table_dateGroupByArgs<ExtArgs>
            result: $Utils.Optional<Table_dateGroupByOutputType>[]
          }
          count: {
            args: Prisma.Table_dateCountArgs<ExtArgs>
            result: $Utils.Optional<Table_dateCountAggregateOutputType> | number
          }
        }
      }
      test_table: {
        payload: Prisma.$test_tablePayload<ExtArgs>
        fields: Prisma.test_tableFieldRefs
        operations: {
          findUnique: {
            args: Prisma.test_tableFindUniqueArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload> | null
          }
          findUniqueOrThrow: {
            args: Prisma.test_tableFindUniqueOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          findFirst: {
            args: Prisma.test_tableFindFirstArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload> | null
          }
          findFirstOrThrow: {
            args: Prisma.test_tableFindFirstOrThrowArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          findMany: {
            args: Prisma.test_tableFindManyArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>[]
          }
          create: {
            args: Prisma.test_tableCreateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          createMany: {
            args: Prisma.test_tableCreateManyArgs<ExtArgs>
            result: BatchPayload
          }
          delete: {
            args: Prisma.test_tableDeleteArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          update: {
            args: Prisma.test_tableUpdateArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          deleteMany: {
            args: Prisma.test_tableDeleteManyArgs<ExtArgs>
            result: BatchPayload
          }
          updateMany: {
            args: Prisma.test_tableUpdateManyArgs<ExtArgs>
            result: BatchPayload
          }
          upsert: {
            args: Prisma.test_tableUpsertArgs<ExtArgs>
            result: $Utils.PayloadToResult<Prisma.$test_tablePayload>
          }
          aggregate: {
            args: Prisma.Test_tableAggregateArgs<ExtArgs>
            result: $Utils.Optional<AggregateTest_table>
          }
          groupBy: {
            args: Prisma.test_tableGroupByArgs<ExtArgs>
            result: $Utils.Optional<Test_tableGroupByOutputType>[]
          }
          count: {
            args: Prisma.test_tableCountArgs<ExtArgs>
            result: $Utils.Optional<Test_tableCountAggregateOutputType> | number
          }
        }
      }
    }
  } & {
    other: {
      payload: any
      operations: {
        $executeRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $executeRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
        $queryRaw: {
          args: [query: TemplateStringsArray | Prisma.Sql, ...values: any[]],
          result: any
        }
        $queryRawUnsafe: {
          args: [query: string, ...values: any[]],
          result: any
        }
      }
    }
  }
  export const defineExtension: $Extensions.ExtendsHook<"define", Prisma.TypeMapCb, $Extensions.DefaultArgs>
  export type DefaultPrismaClient = PrismaClient
  export type ErrorFormat = 'pretty' | 'colorless' | 'minimal'
  export interface PrismaClientOptions {
    /**
     * Overwrites the datasource url from your schema.prisma file
     */
    datasources?: Datasources
    /**
     * Overwrites the datasource url from your schema.prisma file
     */
    datasourceUrl?: string
    /**
     * @default "colorless"
     */
    errorFormat?: ErrorFormat
    /**
     * @example
     * ```
     * // Defaults to stdout
     * log: ['query', 'info', 'warn', 'error']
     * 
     * // Emit as events
     * log: [
     *   { emit: 'stdout', level: 'query' },
     *   { emit: 'stdout', level: 'info' },
     *   { emit: 'stdout', level: 'warn' }
     *   { emit: 'stdout', level: 'error' }
     * ]
     * ```
     * Read more in our [docs](https://www.prisma.io/docs/reference/tools-and-interfaces/prisma-client/logging#the-log-option).
     */
    log?: (LogLevel | LogDefinition)[]
    /**
     * The default values for transactionOptions
     * maxWait ?= 2000
     * timeout ?= 5000
     */
    transactionOptions?: {
      maxWait?: number
      timeout?: number
      isolationLevel?: Prisma.TransactionIsolationLevel
    }
    /**
     * Global configuration for omitting model fields by default.
     * 
     * @example
     * ```
     * const prisma = new PrismaClient({
     *   omit: {
     *     user: {
     *       password: true
     *     }
     *   }
     * })
     * ```
     */
    omit?: Prisma.GlobalOmitConfig
  }
  export type GlobalOmitConfig = {
    table_date?: Table_dateOmit
    test_table?: test_tableOmit
  }

  /* Types for Logging */
  export type LogLevel = 'info' | 'query' | 'warn' | 'error'
  export type LogDefinition = {
    level: LogLevel
    emit: 'stdout' | 'event'
  }

  export type GetLogType<T extends LogLevel | LogDefinition> = T extends LogDefinition ? T['emit'] extends 'event' ? T['level'] : never : never
  export type GetEvents<T extends any> = T extends Array<LogLevel | LogDefinition> ?
    GetLogType<T[0]> | GetLogType<T[1]> | GetLogType<T[2]> | GetLogType<T[3]>
    : never

  export type QueryEvent = {
    timestamp: Date
    query: string
    params: string
    duration: number
    target: string
  }

  export type LogEvent = {
    timestamp: Date
    message: string
    target: string
  }
  /* End Types for Logging */


  export type PrismaAction =
    | 'findUnique'
    | 'findUniqueOrThrow'
    | 'findMany'
    | 'findFirst'
    | 'findFirstOrThrow'
    | 'create'
    | 'createMany'
    | 'createManyAndReturn'
    | 'update'
    | 'updateMany'
    | 'updateManyAndReturn'
    | 'upsert'
    | 'delete'
    | 'deleteMany'
    | 'executeRaw'
    | 'queryRaw'
    | 'aggregate'
    | 'count'
    | 'runCommandRaw'
    | 'findRaw'
    | 'groupBy'

  /**
   * These options are being passed into the middleware as "params"
   */
  export type MiddlewareParams = {
    model?: ModelName
    action: PrismaAction
    args: any
    dataPath: string[]
    runInTransaction: boolean
  }

  /**
   * The `T` type makes sure, that the `return proceed` is not forgotten in the middleware implementation
   */
  export type Middleware<T = any> = (
    params: MiddlewareParams,
    next: (params: MiddlewareParams) => $Utils.JsPromise<T>,
  ) => $Utils.JsPromise<T>

  // tested in getLogLevel.test.ts
  export function getLogLevel(log: Array<LogLevel | LogDefinition>): LogLevel | undefined;

  /**
   * `PrismaClient` proxy available in interactive transactions.
   */
  export type TransactionClient = Omit<Prisma.DefaultPrismaClient, runtime.ITXClientDenyList>

  export type Datasource = {
    url?: string
  }

  /**
   * Count Types
   */



  /**
   * Models
   */

  /**
   * Model Table_date
   */

  export type AggregateTable_date = {
    _count: Table_dateCountAggregateOutputType | null
    _avg: Table_dateAvgAggregateOutputType | null
    _sum: Table_dateSumAggregateOutputType | null
    _min: Table_dateMinAggregateOutputType | null
    _max: Table_dateMaxAggregateOutputType | null
  }

  export type Table_dateAvgAggregateOutputType = {
    id: number | null
  }

  export type Table_dateSumAggregateOutputType = {
    id: number | null
  }

  export type Table_dateMinAggregateOutputType = {
    id: number | null
    date: Date | null
  }

  export type Table_dateMaxAggregateOutputType = {
    id: number | null
    date: Date | null
  }

  export type Table_dateCountAggregateOutputType = {
    id: number
    date: number
    _all: number
  }


  export type Table_dateAvgAggregateInputType = {
    id?: true
  }

  export type Table_dateSumAggregateInputType = {
    id?: true
  }

  export type Table_dateMinAggregateInputType = {
    id?: true
    date?: true
  }

  export type Table_dateMaxAggregateInputType = {
    id?: true
    date?: true
  }

  export type Table_dateCountAggregateInputType = {
    id?: true
    date?: true
    _all?: true
  }

  export type Table_dateAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Table_date to aggregate.
     */
    where?: Table_dateWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Table_dates to fetch.
     */
    orderBy?: Table_dateOrderByWithRelationInput | Table_dateOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: Table_dateWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Table_dates from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Table_dates.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned Table_dates
    **/
    _count?: true | Table_dateCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: Table_dateAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: Table_dateSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: Table_dateMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: Table_dateMaxAggregateInputType
  }

  export type GetTable_dateAggregateType<T extends Table_dateAggregateArgs> = {
        [P in keyof T & keyof AggregateTable_date]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateTable_date[P]>
      : GetScalarType<T[P], AggregateTable_date[P]>
  }




  export type Table_dateGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: Table_dateWhereInput
    orderBy?: Table_dateOrderByWithAggregationInput | Table_dateOrderByWithAggregationInput[]
    by: Table_dateScalarFieldEnum[] | Table_dateScalarFieldEnum
    having?: Table_dateScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: Table_dateCountAggregateInputType | true
    _avg?: Table_dateAvgAggregateInputType
    _sum?: Table_dateSumAggregateInputType
    _min?: Table_dateMinAggregateInputType
    _max?: Table_dateMaxAggregateInputType
  }

  export type Table_dateGroupByOutputType = {
    id: number
    date: Date | null
    _count: Table_dateCountAggregateOutputType | null
    _avg: Table_dateAvgAggregateOutputType | null
    _sum: Table_dateSumAggregateOutputType | null
    _min: Table_dateMinAggregateOutputType | null
    _max: Table_dateMaxAggregateOutputType | null
  }

  type GetTable_dateGroupByPayload<T extends Table_dateGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<Table_dateGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof Table_dateGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], Table_dateGroupByOutputType[P]>
            : GetScalarType<T[P], Table_dateGroupByOutputType[P]>
        }
      >
    >


  export type Table_dateSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    date?: boolean
  }, ExtArgs["result"]["table_date"]>



  export type Table_dateSelectScalar = {
    id?: boolean
    date?: boolean
  }

  export type Table_dateOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "date", ExtArgs["result"]["table_date"]>

  export type $Table_datePayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "Table_date"
    objects: {}
    scalars: $Extensions.GetPayloadResult<{
      id: number
      date: Date | null
    }, ExtArgs["result"]["table_date"]>
    composites: {}
  }

  type Table_dateGetPayload<S extends boolean | null | undefined | Table_dateDefaultArgs> = $Result.GetResult<Prisma.$Table_datePayload, S>

  type Table_dateCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<Table_dateFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: Table_dateCountAggregateInputType | true
    }

  export interface Table_dateDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['Table_date'], meta: { name: 'Table_date' } }
    /**
     * Find zero or one Table_date that matches the filter.
     * @param {Table_dateFindUniqueArgs} args - Arguments to find a Table_date
     * @example
     * // Get one Table_date
     * const table_date = await prisma.table_date.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends Table_dateFindUniqueArgs>(args: SelectSubset<T, Table_dateFindUniqueArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "findUnique", ClientOptions> | null, null, ExtArgs, ClientOptions>

    /**
     * Find one Table_date that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {Table_dateFindUniqueOrThrowArgs} args - Arguments to find a Table_date
     * @example
     * // Get one Table_date
     * const table_date = await prisma.table_date.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends Table_dateFindUniqueOrThrowArgs>(args: SelectSubset<T, Table_dateFindUniqueOrThrowArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "findUniqueOrThrow", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Find the first Table_date that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateFindFirstArgs} args - Arguments to find a Table_date
     * @example
     * // Get one Table_date
     * const table_date = await prisma.table_date.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends Table_dateFindFirstArgs>(args?: SelectSubset<T, Table_dateFindFirstArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "findFirst", ClientOptions> | null, null, ExtArgs, ClientOptions>

    /**
     * Find the first Table_date that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateFindFirstOrThrowArgs} args - Arguments to find a Table_date
     * @example
     * // Get one Table_date
     * const table_date = await prisma.table_date.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends Table_dateFindFirstOrThrowArgs>(args?: SelectSubset<T, Table_dateFindFirstOrThrowArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "findFirstOrThrow", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Find zero or more Table_dates that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all Table_dates
     * const table_dates = await prisma.table_date.findMany()
     * 
     * // Get first 10 Table_dates
     * const table_dates = await prisma.table_date.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const table_dateWithIdOnly = await prisma.table_date.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends Table_dateFindManyArgs>(args?: SelectSubset<T, Table_dateFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "findMany", ClientOptions>>

    /**
     * Create a Table_date.
     * @param {Table_dateCreateArgs} args - Arguments to create a Table_date.
     * @example
     * // Create one Table_date
     * const Table_date = await prisma.table_date.create({
     *   data: {
     *     // ... data to create a Table_date
     *   }
     * })
     * 
     */
    create<T extends Table_dateCreateArgs>(args: SelectSubset<T, Table_dateCreateArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "create", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Create many Table_dates.
     * @param {Table_dateCreateManyArgs} args - Arguments to create many Table_dates.
     * @example
     * // Create many Table_dates
     * const table_date = await prisma.table_date.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends Table_dateCreateManyArgs>(args?: SelectSubset<T, Table_dateCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a Table_date.
     * @param {Table_dateDeleteArgs} args - Arguments to delete one Table_date.
     * @example
     * // Delete one Table_date
     * const Table_date = await prisma.table_date.delete({
     *   where: {
     *     // ... filter to delete one Table_date
     *   }
     * })
     * 
     */
    delete<T extends Table_dateDeleteArgs>(args: SelectSubset<T, Table_dateDeleteArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "delete", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Update one Table_date.
     * @param {Table_dateUpdateArgs} args - Arguments to update one Table_date.
     * @example
     * // Update one Table_date
     * const table_date = await prisma.table_date.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends Table_dateUpdateArgs>(args: SelectSubset<T, Table_dateUpdateArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "update", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Delete zero or more Table_dates.
     * @param {Table_dateDeleteManyArgs} args - Arguments to filter Table_dates to delete.
     * @example
     * // Delete a few Table_dates
     * const { count } = await prisma.table_date.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends Table_dateDeleteManyArgs>(args?: SelectSubset<T, Table_dateDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more Table_dates.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many Table_dates
     * const table_date = await prisma.table_date.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends Table_dateUpdateManyArgs>(args: SelectSubset<T, Table_dateUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one Table_date.
     * @param {Table_dateUpsertArgs} args - Arguments to update or create a Table_date.
     * @example
     * // Update or create a Table_date
     * const table_date = await prisma.table_date.upsert({
     *   create: {
     *     // ... data to create a Table_date
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the Table_date we want to update
     *   }
     * })
     */
    upsert<T extends Table_dateUpsertArgs>(args: SelectSubset<T, Table_dateUpsertArgs<ExtArgs>>): Prisma__Table_dateClient<$Result.GetResult<Prisma.$Table_datePayload<ExtArgs>, T, "upsert", ClientOptions>, never, ExtArgs, ClientOptions>


    /**
     * Count the number of Table_dates.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateCountArgs} args - Arguments to filter Table_dates to count.
     * @example
     * // Count the number of Table_dates
     * const count = await prisma.table_date.count({
     *   where: {
     *     // ... the filter for the Table_dates we want to count
     *   }
     * })
    **/
    count<T extends Table_dateCountArgs>(
      args?: Subset<T, Table_dateCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], Table_dateCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a Table_date.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends Table_dateAggregateArgs>(args: Subset<T, Table_dateAggregateArgs>): Prisma.PrismaPromise<GetTable_dateAggregateType<T>>

    /**
     * Group by Table_date.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Table_dateGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends Table_dateGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: Table_dateGroupByArgs['orderBy'] }
        : { orderBy?: Table_dateGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, Table_dateGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetTable_dateGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the Table_date model
   */
  readonly fields: Table_dateFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for Table_date.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__Table_dateClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the Table_date model
   */ 
  interface Table_dateFieldRefs {
    readonly id: FieldRef<"Table_date", 'Int'>
    readonly date: FieldRef<"Table_date", 'DateTime'>
  }
    

  // Custom InputTypes
  /**
   * Table_date findUnique
   */
  export type Table_dateFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter, which Table_date to fetch.
     */
    where: Table_dateWhereUniqueInput
  }

  /**
   * Table_date findUniqueOrThrow
   */
  export type Table_dateFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter, which Table_date to fetch.
     */
    where: Table_dateWhereUniqueInput
  }

  /**
   * Table_date findFirst
   */
  export type Table_dateFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter, which Table_date to fetch.
     */
    where?: Table_dateWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Table_dates to fetch.
     */
    orderBy?: Table_dateOrderByWithRelationInput | Table_dateOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Table_dates.
     */
    cursor?: Table_dateWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Table_dates from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Table_dates.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Table_dates.
     */
    distinct?: Table_dateScalarFieldEnum | Table_dateScalarFieldEnum[]
  }

  /**
   * Table_date findFirstOrThrow
   */
  export type Table_dateFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter, which Table_date to fetch.
     */
    where?: Table_dateWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Table_dates to fetch.
     */
    orderBy?: Table_dateOrderByWithRelationInput | Table_dateOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for Table_dates.
     */
    cursor?: Table_dateWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Table_dates from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Table_dates.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of Table_dates.
     */
    distinct?: Table_dateScalarFieldEnum | Table_dateScalarFieldEnum[]
  }

  /**
   * Table_date findMany
   */
  export type Table_dateFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter, which Table_dates to fetch.
     */
    where?: Table_dateWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of Table_dates to fetch.
     */
    orderBy?: Table_dateOrderByWithRelationInput | Table_dateOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing Table_dates.
     */
    cursor?: Table_dateWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` Table_dates from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` Table_dates.
     */
    skip?: number
    distinct?: Table_dateScalarFieldEnum | Table_dateScalarFieldEnum[]
  }

  /**
   * Table_date create
   */
  export type Table_dateCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * The data needed to create a Table_date.
     */
    data?: XOR<Table_dateCreateInput, Table_dateUncheckedCreateInput>
  }

  /**
   * Table_date createMany
   */
  export type Table_dateCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many Table_dates.
     */
    data: Table_dateCreateManyInput | Table_dateCreateManyInput[]
  }

  /**
   * Table_date update
   */
  export type Table_dateUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * The data needed to update a Table_date.
     */
    data: XOR<Table_dateUpdateInput, Table_dateUncheckedUpdateInput>
    /**
     * Choose, which Table_date to update.
     */
    where: Table_dateWhereUniqueInput
  }

  /**
   * Table_date updateMany
   */
  export type Table_dateUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update Table_dates.
     */
    data: XOR<Table_dateUpdateManyMutationInput, Table_dateUncheckedUpdateManyInput>
    /**
     * Filter which Table_dates to update
     */
    where?: Table_dateWhereInput
  }

  /**
   * Table_date upsert
   */
  export type Table_dateUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * The filter to search for the Table_date to update in case it exists.
     */
    where: Table_dateWhereUniqueInput
    /**
     * In case the Table_date found by the `where` argument doesn't exist, create a new Table_date with this data.
     */
    create: XOR<Table_dateCreateInput, Table_dateUncheckedCreateInput>
    /**
     * In case the Table_date was found with the provided `where` argument, update it with this data.
     */
    update: XOR<Table_dateUpdateInput, Table_dateUncheckedUpdateInput>
  }

  /**
   * Table_date delete
   */
  export type Table_dateDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
    /**
     * Filter which Table_date to delete.
     */
    where: Table_dateWhereUniqueInput
  }

  /**
   * Table_date deleteMany
   */
  export type Table_dateDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which Table_dates to delete
     */
    where?: Table_dateWhereInput
  }

  /**
   * Table_date without action
   */
  export type Table_dateDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the Table_date
     */
    select?: Table_dateSelect<ExtArgs> | null
    /**
     * Omit specific fields from the Table_date
     */
    omit?: Table_dateOmit<ExtArgs> | null
  }


  /**
   * Model test_table
   */

  export type AggregateTest_table = {
    _count: Test_tableCountAggregateOutputType | null
    _avg: Test_tableAvgAggregateOutputType | null
    _sum: Test_tableSumAggregateOutputType | null
    _min: Test_tableMinAggregateOutputType | null
    _max: Test_tableMaxAggregateOutputType | null
  }

  export type Test_tableAvgAggregateOutputType = {
    id: number | null
  }

  export type Test_tableSumAggregateOutputType = {
    id: number | null
  }

  export type Test_tableMinAggregateOutputType = {
    id: number | null
    test_table_str: string | null
  }

  export type Test_tableMaxAggregateOutputType = {
    id: number | null
    test_table_str: string | null
  }

  export type Test_tableCountAggregateOutputType = {
    id: number
    test_table_str: number
    _all: number
  }


  export type Test_tableAvgAggregateInputType = {
    id?: true
  }

  export type Test_tableSumAggregateInputType = {
    id?: true
  }

  export type Test_tableMinAggregateInputType = {
    id?: true
    test_table_str?: true
  }

  export type Test_tableMaxAggregateInputType = {
    id?: true
    test_table_str?: true
  }

  export type Test_tableCountAggregateInputType = {
    id?: true
    test_table_str?: true
    _all?: true
  }

  export type Test_tableAggregateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which test_table to aggregate.
     */
    where?: test_tableWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of test_tables to fetch.
     */
    orderBy?: test_tableOrderByWithRelationInput | test_tableOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the start position
     */
    cursor?: test_tableWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` test_tables from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` test_tables.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Count returned test_tables
    **/
    _count?: true | Test_tableCountAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to average
    **/
    _avg?: Test_tableAvgAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to sum
    **/
    _sum?: Test_tableSumAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the minimum value
    **/
    _min?: Test_tableMinAggregateInputType
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/aggregations Aggregation Docs}
     * 
     * Select which fields to find the maximum value
    **/
    _max?: Test_tableMaxAggregateInputType
  }

  export type GetTest_tableAggregateType<T extends Test_tableAggregateArgs> = {
        [P in keyof T & keyof AggregateTest_table]: P extends '_count' | 'count'
      ? T[P] extends true
        ? number
        : GetScalarType<T[P], AggregateTest_table[P]>
      : GetScalarType<T[P], AggregateTest_table[P]>
  }




  export type test_tableGroupByArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    where?: test_tableWhereInput
    orderBy?: test_tableOrderByWithAggregationInput | test_tableOrderByWithAggregationInput[]
    by: Test_tableScalarFieldEnum[] | Test_tableScalarFieldEnum
    having?: test_tableScalarWhereWithAggregatesInput
    take?: number
    skip?: number
    _count?: Test_tableCountAggregateInputType | true
    _avg?: Test_tableAvgAggregateInputType
    _sum?: Test_tableSumAggregateInputType
    _min?: Test_tableMinAggregateInputType
    _max?: Test_tableMaxAggregateInputType
  }

  export type Test_tableGroupByOutputType = {
    id: number
    test_table_str: string | null
    _count: Test_tableCountAggregateOutputType | null
    _avg: Test_tableAvgAggregateOutputType | null
    _sum: Test_tableSumAggregateOutputType | null
    _min: Test_tableMinAggregateOutputType | null
    _max: Test_tableMaxAggregateOutputType | null
  }

  type GetTest_tableGroupByPayload<T extends test_tableGroupByArgs> = Prisma.PrismaPromise<
    Array<
      PickEnumerable<Test_tableGroupByOutputType, T['by']> &
        {
          [P in ((keyof T) & (keyof Test_tableGroupByOutputType))]: P extends '_count'
            ? T[P] extends boolean
              ? number
              : GetScalarType<T[P], Test_tableGroupByOutputType[P]>
            : GetScalarType<T[P], Test_tableGroupByOutputType[P]>
        }
      >
    >


  export type test_tableSelect<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetSelect<{
    id?: boolean
    test_table_str?: boolean
  }, ExtArgs["result"]["test_table"]>



  export type test_tableSelectScalar = {
    id?: boolean
    test_table_str?: boolean
  }

  export type test_tableOmit<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = $Extensions.GetOmit<"id" | "test_table_str", ExtArgs["result"]["test_table"]>

  export type $test_tablePayload<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    name: "test_table"
    objects: {}
    scalars: $Extensions.GetPayloadResult<{
      id: number
      test_table_str: string | null
    }, ExtArgs["result"]["test_table"]>
    composites: {}
  }

  type test_tableGetPayload<S extends boolean | null | undefined | test_tableDefaultArgs> = $Result.GetResult<Prisma.$test_tablePayload, S>

  type test_tableCountArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> =
    Omit<test_tableFindManyArgs, 'select' | 'include' | 'distinct' | 'omit'> & {
      select?: Test_tableCountAggregateInputType | true
    }

  export interface test_tableDelegate<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> {
    [K: symbol]: { types: Prisma.TypeMap<ExtArgs>['model']['test_table'], meta: { name: 'test_table' } }
    /**
     * Find zero or one Test_table that matches the filter.
     * @param {test_tableFindUniqueArgs} args - Arguments to find a Test_table
     * @example
     * // Get one Test_table
     * const test_table = await prisma.test_table.findUnique({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUnique<T extends test_tableFindUniqueArgs>(args: SelectSubset<T, test_tableFindUniqueArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "findUnique", ClientOptions> | null, null, ExtArgs, ClientOptions>

    /**
     * Find one Test_table that matches the filter or throw an error with `error.code='P2025'`
     * if no matches were found.
     * @param {test_tableFindUniqueOrThrowArgs} args - Arguments to find a Test_table
     * @example
     * // Get one Test_table
     * const test_table = await prisma.test_table.findUniqueOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findUniqueOrThrow<T extends test_tableFindUniqueOrThrowArgs>(args: SelectSubset<T, test_tableFindUniqueOrThrowArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "findUniqueOrThrow", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Find the first Test_table that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableFindFirstArgs} args - Arguments to find a Test_table
     * @example
     * // Get one Test_table
     * const test_table = await prisma.test_table.findFirst({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirst<T extends test_tableFindFirstArgs>(args?: SelectSubset<T, test_tableFindFirstArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "findFirst", ClientOptions> | null, null, ExtArgs, ClientOptions>

    /**
     * Find the first Test_table that matches the filter or
     * throw `PrismaKnownClientError` with `P2025` code if no matches were found.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableFindFirstOrThrowArgs} args - Arguments to find a Test_table
     * @example
     * // Get one Test_table
     * const test_table = await prisma.test_table.findFirstOrThrow({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     */
    findFirstOrThrow<T extends test_tableFindFirstOrThrowArgs>(args?: SelectSubset<T, test_tableFindFirstOrThrowArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "findFirstOrThrow", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Find zero or more Test_tables that matches the filter.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableFindManyArgs} args - Arguments to filter and select certain fields only.
     * @example
     * // Get all Test_tables
     * const test_tables = await prisma.test_table.findMany()
     * 
     * // Get first 10 Test_tables
     * const test_tables = await prisma.test_table.findMany({ take: 10 })
     * 
     * // Only select the `id`
     * const test_tableWithIdOnly = await prisma.test_table.findMany({ select: { id: true } })
     * 
     */
    findMany<T extends test_tableFindManyArgs>(args?: SelectSubset<T, test_tableFindManyArgs<ExtArgs>>): Prisma.PrismaPromise<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "findMany", ClientOptions>>

    /**
     * Create a Test_table.
     * @param {test_tableCreateArgs} args - Arguments to create a Test_table.
     * @example
     * // Create one Test_table
     * const Test_table = await prisma.test_table.create({
     *   data: {
     *     // ... data to create a Test_table
     *   }
     * })
     * 
     */
    create<T extends test_tableCreateArgs>(args: SelectSubset<T, test_tableCreateArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "create", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Create many Test_tables.
     * @param {test_tableCreateManyArgs} args - Arguments to create many Test_tables.
     * @example
     * // Create many Test_tables
     * const test_table = await prisma.test_table.createMany({
     *   data: [
     *     // ... provide data here
     *   ]
     * })
     *     
     */
    createMany<T extends test_tableCreateManyArgs>(args?: SelectSubset<T, test_tableCreateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Delete a Test_table.
     * @param {test_tableDeleteArgs} args - Arguments to delete one Test_table.
     * @example
     * // Delete one Test_table
     * const Test_table = await prisma.test_table.delete({
     *   where: {
     *     // ... filter to delete one Test_table
     *   }
     * })
     * 
     */
    delete<T extends test_tableDeleteArgs>(args: SelectSubset<T, test_tableDeleteArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "delete", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Update one Test_table.
     * @param {test_tableUpdateArgs} args - Arguments to update one Test_table.
     * @example
     * // Update one Test_table
     * const test_table = await prisma.test_table.update({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    update<T extends test_tableUpdateArgs>(args: SelectSubset<T, test_tableUpdateArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "update", ClientOptions>, never, ExtArgs, ClientOptions>

    /**
     * Delete zero or more Test_tables.
     * @param {test_tableDeleteManyArgs} args - Arguments to filter Test_tables to delete.
     * @example
     * // Delete a few Test_tables
     * const { count } = await prisma.test_table.deleteMany({
     *   where: {
     *     // ... provide filter here
     *   }
     * })
     * 
     */
    deleteMany<T extends test_tableDeleteManyArgs>(args?: SelectSubset<T, test_tableDeleteManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Update zero or more Test_tables.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableUpdateManyArgs} args - Arguments to update one or more rows.
     * @example
     * // Update many Test_tables
     * const test_table = await prisma.test_table.updateMany({
     *   where: {
     *     // ... provide filter here
     *   },
     *   data: {
     *     // ... provide data here
     *   }
     * })
     * 
     */
    updateMany<T extends test_tableUpdateManyArgs>(args: SelectSubset<T, test_tableUpdateManyArgs<ExtArgs>>): Prisma.PrismaPromise<BatchPayload>

    /**
     * Create or update one Test_table.
     * @param {test_tableUpsertArgs} args - Arguments to update or create a Test_table.
     * @example
     * // Update or create a Test_table
     * const test_table = await prisma.test_table.upsert({
     *   create: {
     *     // ... data to create a Test_table
     *   },
     *   update: {
     *     // ... in case it already exists, update
     *   },
     *   where: {
     *     // ... the filter for the Test_table we want to update
     *   }
     * })
     */
    upsert<T extends test_tableUpsertArgs>(args: SelectSubset<T, test_tableUpsertArgs<ExtArgs>>): Prisma__test_tableClient<$Result.GetResult<Prisma.$test_tablePayload<ExtArgs>, T, "upsert", ClientOptions>, never, ExtArgs, ClientOptions>


    /**
     * Count the number of Test_tables.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableCountArgs} args - Arguments to filter Test_tables to count.
     * @example
     * // Count the number of Test_tables
     * const count = await prisma.test_table.count({
     *   where: {
     *     // ... the filter for the Test_tables we want to count
     *   }
     * })
    **/
    count<T extends test_tableCountArgs>(
      args?: Subset<T, test_tableCountArgs>,
    ): Prisma.PrismaPromise<
      T extends $Utils.Record<'select', any>
        ? T['select'] extends true
          ? number
          : GetScalarType<T['select'], Test_tableCountAggregateOutputType>
        : number
    >

    /**
     * Allows you to perform aggregations operations on a Test_table.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {Test_tableAggregateArgs} args - Select which aggregations you would like to apply and on what fields.
     * @example
     * // Ordered by age ascending
     * // Where email contains prisma.io
     * // Limited to the 10 users
     * const aggregations = await prisma.user.aggregate({
     *   _avg: {
     *     age: true,
     *   },
     *   where: {
     *     email: {
     *       contains: "prisma.io",
     *     },
     *   },
     *   orderBy: {
     *     age: "asc",
     *   },
     *   take: 10,
     * })
    **/
    aggregate<T extends Test_tableAggregateArgs>(args: Subset<T, Test_tableAggregateArgs>): Prisma.PrismaPromise<GetTest_tableAggregateType<T>>

    /**
     * Group by Test_table.
     * Note, that providing `undefined` is treated as the value not being there.
     * Read more here: https://pris.ly/d/null-undefined
     * @param {test_tableGroupByArgs} args - Group by arguments.
     * @example
     * // Group by city, order by createdAt, get count
     * const result = await prisma.user.groupBy({
     *   by: ['city', 'createdAt'],
     *   orderBy: {
     *     createdAt: true
     *   },
     *   _count: {
     *     _all: true
     *   },
     * })
     * 
    **/
    groupBy<
      T extends test_tableGroupByArgs,
      HasSelectOrTake extends Or<
        Extends<'skip', Keys<T>>,
        Extends<'take', Keys<T>>
      >,
      OrderByArg extends True extends HasSelectOrTake
        ? { orderBy: test_tableGroupByArgs['orderBy'] }
        : { orderBy?: test_tableGroupByArgs['orderBy'] },
      OrderFields extends ExcludeUnderscoreKeys<Keys<MaybeTupleToUnion<T['orderBy']>>>,
      ByFields extends MaybeTupleToUnion<T['by']>,
      ByValid extends Has<ByFields, OrderFields>,
      HavingFields extends GetHavingFields<T['having']>,
      HavingValid extends Has<ByFields, HavingFields>,
      ByEmpty extends T['by'] extends never[] ? True : False,
      InputErrors extends ByEmpty extends True
      ? `Error: "by" must not be empty.`
      : HavingValid extends False
      ? {
          [P in HavingFields]: P extends ByFields
            ? never
            : P extends string
            ? `Error: Field "${P}" used in "having" needs to be provided in "by".`
            : [
                Error,
                'Field ',
                P,
                ` in "having" needs to be provided in "by"`,
              ]
        }[HavingFields]
      : 'take' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "take", you also need to provide "orderBy"'
      : 'skip' extends Keys<T>
      ? 'orderBy' extends Keys<T>
        ? ByValid extends True
          ? {}
          : {
              [P in OrderFields]: P extends ByFields
                ? never
                : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
            }[OrderFields]
        : 'Error: If you provide "skip", you also need to provide "orderBy"'
      : ByValid extends True
      ? {}
      : {
          [P in OrderFields]: P extends ByFields
            ? never
            : `Error: Field "${P}" in "orderBy" needs to be provided in "by"`
        }[OrderFields]
    >(args: SubsetIntersection<T, test_tableGroupByArgs, OrderByArg> & InputErrors): {} extends InputErrors ? GetTest_tableGroupByPayload<T> : Prisma.PrismaPromise<InputErrors>
  /**
   * Fields of the test_table model
   */
  readonly fields: test_tableFieldRefs;
  }

  /**
   * The delegate class that acts as a "Promise-like" for test_table.
   * Why is this prefixed with `Prisma__`?
   * Because we want to prevent naming conflicts as mentioned in
   * https://github.com/prisma/prisma-client-js/issues/707
   */
  export interface Prisma__test_tableClient<T, Null = never, ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs, ClientOptions = {}> extends Prisma.PrismaPromise<T> {
    readonly [Symbol.toStringTag]: "PrismaPromise"
    /**
     * Attaches callbacks for the resolution and/or rejection of the Promise.
     * @param onfulfilled The callback to execute when the Promise is resolved.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of which ever callback is executed.
     */
    then<TResult1 = T, TResult2 = never>(onfulfilled?: ((value: T) => TResult1 | PromiseLike<TResult1>) | undefined | null, onrejected?: ((reason: any) => TResult2 | PromiseLike<TResult2>) | undefined | null): $Utils.JsPromise<TResult1 | TResult2>
    /**
     * Attaches a callback for only the rejection of the Promise.
     * @param onrejected The callback to execute when the Promise is rejected.
     * @returns A Promise for the completion of the callback.
     */
    catch<TResult = never>(onrejected?: ((reason: any) => TResult | PromiseLike<TResult>) | undefined | null): $Utils.JsPromise<T | TResult>
    /**
     * Attaches a callback that is invoked when the Promise is settled (fulfilled or rejected). The
     * resolved value cannot be modified from the callback.
     * @param onfinally The callback to execute when the Promise is settled (fulfilled or rejected).
     * @returns A Promise for the completion of the callback.
     */
    finally(onfinally?: (() => void) | undefined | null): $Utils.JsPromise<T>
  }




  /**
   * Fields of the test_table model
   */ 
  interface test_tableFieldRefs {
    readonly id: FieldRef<"test_table", 'Int'>
    readonly test_table_str: FieldRef<"test_table", 'String'>
  }
    

  // Custom InputTypes
  /**
   * test_table findUnique
   */
  export type test_tableFindUniqueArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter, which test_table to fetch.
     */
    where: test_tableWhereUniqueInput
  }

  /**
   * test_table findUniqueOrThrow
   */
  export type test_tableFindUniqueOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter, which test_table to fetch.
     */
    where: test_tableWhereUniqueInput
  }

  /**
   * test_table findFirst
   */
  export type test_tableFindFirstArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter, which test_table to fetch.
     */
    where?: test_tableWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of test_tables to fetch.
     */
    orderBy?: test_tableOrderByWithRelationInput | test_tableOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for test_tables.
     */
    cursor?: test_tableWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` test_tables from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` test_tables.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of test_tables.
     */
    distinct?: Test_tableScalarFieldEnum | Test_tableScalarFieldEnum[]
  }

  /**
   * test_table findFirstOrThrow
   */
  export type test_tableFindFirstOrThrowArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter, which test_table to fetch.
     */
    where?: test_tableWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of test_tables to fetch.
     */
    orderBy?: test_tableOrderByWithRelationInput | test_tableOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for searching for test_tables.
     */
    cursor?: test_tableWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` test_tables from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` test_tables.
     */
    skip?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/distinct Distinct Docs}
     * 
     * Filter by unique combinations of test_tables.
     */
    distinct?: Test_tableScalarFieldEnum | Test_tableScalarFieldEnum[]
  }

  /**
   * test_table findMany
   */
  export type test_tableFindManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter, which test_tables to fetch.
     */
    where?: test_tableWhereInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/sorting Sorting Docs}
     * 
     * Determine the order of test_tables to fetch.
     */
    orderBy?: test_tableOrderByWithRelationInput | test_tableOrderByWithRelationInput[]
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination#cursor-based-pagination Cursor Docs}
     * 
     * Sets the position for listing test_tables.
     */
    cursor?: test_tableWhereUniqueInput
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Take `±n` test_tables from the position of the cursor.
     */
    take?: number
    /**
     * {@link https://www.prisma.io/docs/concepts/components/prisma-client/pagination Pagination Docs}
     * 
     * Skip the first `n` test_tables.
     */
    skip?: number
    distinct?: Test_tableScalarFieldEnum | Test_tableScalarFieldEnum[]
  }

  /**
   * test_table create
   */
  export type test_tableCreateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * The data needed to create a test_table.
     */
    data?: XOR<test_tableCreateInput, test_tableUncheckedCreateInput>
  }

  /**
   * test_table createMany
   */
  export type test_tableCreateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to create many test_tables.
     */
    data: test_tableCreateManyInput | test_tableCreateManyInput[]
  }

  /**
   * test_table update
   */
  export type test_tableUpdateArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * The data needed to update a test_table.
     */
    data: XOR<test_tableUpdateInput, test_tableUncheckedUpdateInput>
    /**
     * Choose, which test_table to update.
     */
    where: test_tableWhereUniqueInput
  }

  /**
   * test_table updateMany
   */
  export type test_tableUpdateManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * The data used to update test_tables.
     */
    data: XOR<test_tableUpdateManyMutationInput, test_tableUncheckedUpdateManyInput>
    /**
     * Filter which test_tables to update
     */
    where?: test_tableWhereInput
  }

  /**
   * test_table upsert
   */
  export type test_tableUpsertArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * The filter to search for the test_table to update in case it exists.
     */
    where: test_tableWhereUniqueInput
    /**
     * In case the test_table found by the `where` argument doesn't exist, create a new test_table with this data.
     */
    create: XOR<test_tableCreateInput, test_tableUncheckedCreateInput>
    /**
     * In case the test_table was found with the provided `where` argument, update it with this data.
     */
    update: XOR<test_tableUpdateInput, test_tableUncheckedUpdateInput>
  }

  /**
   * test_table delete
   */
  export type test_tableDeleteArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
    /**
     * Filter which test_table to delete.
     */
    where: test_tableWhereUniqueInput
  }

  /**
   * test_table deleteMany
   */
  export type test_tableDeleteManyArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Filter which test_tables to delete
     */
    where?: test_tableWhereInput
  }

  /**
   * test_table without action
   */
  export type test_tableDefaultArgs<ExtArgs extends $Extensions.InternalArgs = $Extensions.DefaultArgs> = {
    /**
     * Select specific fields to fetch from the test_table
     */
    select?: test_tableSelect<ExtArgs> | null
    /**
     * Omit specific fields from the test_table
     */
    omit?: test_tableOmit<ExtArgs> | null
  }


  /**
   * Enums
   */

  export const TransactionIsolationLevel: {
    ReadUncommitted: 'ReadUncommitted',
    ReadCommitted: 'ReadCommitted',
    RepeatableRead: 'RepeatableRead',
    Serializable: 'Serializable',
    Snapshot: 'Snapshot'
  };

  export type TransactionIsolationLevel = (typeof TransactionIsolationLevel)[keyof typeof TransactionIsolationLevel]


  export const Table_dateScalarFieldEnum: {
    id: 'id',
    date: 'date'
  };

  export type Table_dateScalarFieldEnum = (typeof Table_dateScalarFieldEnum)[keyof typeof Table_dateScalarFieldEnum]


  export const Test_tableScalarFieldEnum: {
    id: 'id',
    test_table_str: 'test_table_str'
  };

  export type Test_tableScalarFieldEnum = (typeof Test_tableScalarFieldEnum)[keyof typeof Test_tableScalarFieldEnum]


  export const SortOrder: {
    asc: 'asc',
    desc: 'desc'
  };

  export type SortOrder = (typeof SortOrder)[keyof typeof SortOrder]


  export const NullsOrder: {
    first: 'first',
    last: 'last'
  };

  export type NullsOrder = (typeof NullsOrder)[keyof typeof NullsOrder]


  /**
   * Field references 
   */


  /**
   * Reference to a field of type 'Int'
   */
  export type IntFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Int'>
    


  /**
   * Reference to a field of type 'DateTime'
   */
  export type DateTimeFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'DateTime'>
    


  /**
   * Reference to a field of type 'String'
   */
  export type StringFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'String'>
    


  /**
   * Reference to a field of type 'Float'
   */
  export type FloatFieldRefInput<$PrismaModel> = FieldRefInputType<$PrismaModel, 'Float'>
    
  /**
   * Deep Input Types
   */


  export type Table_dateWhereInput = {
    AND?: Table_dateWhereInput | Table_dateWhereInput[]
    OR?: Table_dateWhereInput[]
    NOT?: Table_dateWhereInput | Table_dateWhereInput[]
    id?: IntFilter<"Table_date"> | number
    date?: DateTimeNullableFilter<"Table_date"> | Date | string | null
  }

  export type Table_dateOrderByWithRelationInput = {
    id?: SortOrder
    date?: SortOrderInput | SortOrder
  }

  export type Table_dateWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    AND?: Table_dateWhereInput | Table_dateWhereInput[]
    OR?: Table_dateWhereInput[]
    NOT?: Table_dateWhereInput | Table_dateWhereInput[]
    date?: DateTimeNullableFilter<"Table_date"> | Date | string | null
  }, "id">

  export type Table_dateOrderByWithAggregationInput = {
    id?: SortOrder
    date?: SortOrderInput | SortOrder
    _count?: Table_dateCountOrderByAggregateInput
    _avg?: Table_dateAvgOrderByAggregateInput
    _max?: Table_dateMaxOrderByAggregateInput
    _min?: Table_dateMinOrderByAggregateInput
    _sum?: Table_dateSumOrderByAggregateInput
  }

  export type Table_dateScalarWhereWithAggregatesInput = {
    AND?: Table_dateScalarWhereWithAggregatesInput | Table_dateScalarWhereWithAggregatesInput[]
    OR?: Table_dateScalarWhereWithAggregatesInput[]
    NOT?: Table_dateScalarWhereWithAggregatesInput | Table_dateScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"Table_date"> | number
    date?: DateTimeNullableWithAggregatesFilter<"Table_date"> | Date | string | null
  }

  export type test_tableWhereInput = {
    AND?: test_tableWhereInput | test_tableWhereInput[]
    OR?: test_tableWhereInput[]
    NOT?: test_tableWhereInput | test_tableWhereInput[]
    id?: IntFilter<"test_table"> | number
    test_table_str?: StringNullableFilter<"test_table"> | string | null
  }

  export type test_tableOrderByWithRelationInput = {
    id?: SortOrder
    test_table_str?: SortOrderInput | SortOrder
  }

  export type test_tableWhereUniqueInput = Prisma.AtLeast<{
    id?: number
    AND?: test_tableWhereInput | test_tableWhereInput[]
    OR?: test_tableWhereInput[]
    NOT?: test_tableWhereInput | test_tableWhereInput[]
    test_table_str?: StringNullableFilter<"test_table"> | string | null
  }, "id">

  export type test_tableOrderByWithAggregationInput = {
    id?: SortOrder
    test_table_str?: SortOrderInput | SortOrder
    _count?: test_tableCountOrderByAggregateInput
    _avg?: test_tableAvgOrderByAggregateInput
    _max?: test_tableMaxOrderByAggregateInput
    _min?: test_tableMinOrderByAggregateInput
    _sum?: test_tableSumOrderByAggregateInput
  }

  export type test_tableScalarWhereWithAggregatesInput = {
    AND?: test_tableScalarWhereWithAggregatesInput | test_tableScalarWhereWithAggregatesInput[]
    OR?: test_tableScalarWhereWithAggregatesInput[]
    NOT?: test_tableScalarWhereWithAggregatesInput | test_tableScalarWhereWithAggregatesInput[]
    id?: IntWithAggregatesFilter<"test_table"> | number
    test_table_str?: StringNullableWithAggregatesFilter<"test_table"> | string | null
  }

  export type Table_dateCreateInput = {
    id?: number
    date?: Date | string | null
  }

  export type Table_dateUncheckedCreateInput = {
    id?: number
    date?: Date | string | null
  }

  export type Table_dateUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    date?: NullableDateTimeFieldUpdateOperationsInput | Date | string | null
  }

  export type Table_dateUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    date?: NullableDateTimeFieldUpdateOperationsInput | Date | string | null
  }

  export type Table_dateCreateManyInput = {
    id?: number
    date?: Date | string | null
  }

  export type Table_dateUpdateManyMutationInput = {
    id?: IntFieldUpdateOperationsInput | number
    date?: NullableDateTimeFieldUpdateOperationsInput | Date | string | null
  }

  export type Table_dateUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    date?: NullableDateTimeFieldUpdateOperationsInput | Date | string | null
  }

  export type test_tableCreateInput = {
    test_table_str?: string | null
  }

  export type test_tableUncheckedCreateInput = {
    id?: number
    test_table_str?: string | null
  }

  export type test_tableUpdateInput = {
    test_table_str?: NullableStringFieldUpdateOperationsInput | string | null
  }

  export type test_tableUncheckedUpdateInput = {
    id?: IntFieldUpdateOperationsInput | number
    test_table_str?: NullableStringFieldUpdateOperationsInput | string | null
  }

  export type test_tableCreateManyInput = {
    test_table_str?: string | null
  }

  export type test_tableUpdateManyMutationInput = {
    test_table_str?: NullableStringFieldUpdateOperationsInput | string | null
  }

  export type test_tableUncheckedUpdateManyInput = {
    id?: IntFieldUpdateOperationsInput | number
    test_table_str?: NullableStringFieldUpdateOperationsInput | string | null
  }

  export type IntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type DateTimeNullableFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel> | null
    in?: Date[] | string[] | null
    notIn?: Date[] | string[] | null
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeNullableFilter<$PrismaModel> | Date | string | null
  }

  export type SortOrderInput = {
    sort: SortOrder
    nulls?: NullsOrder
  }

  export type Table_dateCountOrderByAggregateInput = {
    id?: SortOrder
    date?: SortOrder
  }

  export type Table_dateAvgOrderByAggregateInput = {
    id?: SortOrder
  }

  export type Table_dateMaxOrderByAggregateInput = {
    id?: SortOrder
    date?: SortOrder
  }

  export type Table_dateMinOrderByAggregateInput = {
    id?: SortOrder
    date?: SortOrder
  }

  export type Table_dateSumOrderByAggregateInput = {
    id?: SortOrder
  }

  export type IntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }

  export type DateTimeNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel> | null
    in?: Date[] | string[] | null
    notIn?: Date[] | string[] | null
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeNullableWithAggregatesFilter<$PrismaModel> | Date | string | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedDateTimeNullableFilter<$PrismaModel>
    _max?: NestedDateTimeNullableFilter<$PrismaModel>
  }

  export type StringNullableFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel> | null
    in?: string[] | null
    notIn?: string[] | null
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringNullableFilter<$PrismaModel> | string | null
  }

  export type test_tableCountOrderByAggregateInput = {
    id?: SortOrder
    test_table_str?: SortOrder
  }

  export type test_tableAvgOrderByAggregateInput = {
    id?: SortOrder
  }

  export type test_tableMaxOrderByAggregateInput = {
    id?: SortOrder
    test_table_str?: SortOrder
  }

  export type test_tableMinOrderByAggregateInput = {
    id?: SortOrder
    test_table_str?: SortOrder
  }

  export type test_tableSumOrderByAggregateInput = {
    id?: SortOrder
  }

  export type StringNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel> | null
    in?: string[] | null
    notIn?: string[] | null
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringNullableWithAggregatesFilter<$PrismaModel> | string | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedStringNullableFilter<$PrismaModel>
    _max?: NestedStringNullableFilter<$PrismaModel>
  }

  export type IntFieldUpdateOperationsInput = {
    set?: number
    increment?: number
    decrement?: number
    multiply?: number
    divide?: number
  }

  export type NullableDateTimeFieldUpdateOperationsInput = {
    set?: Date | string | null
  }

  export type NullableStringFieldUpdateOperationsInput = {
    set?: string | null
  }

  export type NestedIntFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntFilter<$PrismaModel> | number
  }

  export type NestedDateTimeNullableFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel> | null
    in?: Date[] | string[] | null
    notIn?: Date[] | string[] | null
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeNullableFilter<$PrismaModel> | Date | string | null
  }

  export type NestedIntWithAggregatesFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntWithAggregatesFilter<$PrismaModel> | number
    _count?: NestedIntFilter<$PrismaModel>
    _avg?: NestedFloatFilter<$PrismaModel>
    _sum?: NestedIntFilter<$PrismaModel>
    _min?: NestedIntFilter<$PrismaModel>
    _max?: NestedIntFilter<$PrismaModel>
  }

  export type NestedFloatFilter<$PrismaModel = never> = {
    equals?: number | FloatFieldRefInput<$PrismaModel>
    in?: number[]
    notIn?: number[]
    lt?: number | FloatFieldRefInput<$PrismaModel>
    lte?: number | FloatFieldRefInput<$PrismaModel>
    gt?: number | FloatFieldRefInput<$PrismaModel>
    gte?: number | FloatFieldRefInput<$PrismaModel>
    not?: NestedFloatFilter<$PrismaModel> | number
  }

  export type NestedDateTimeNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: Date | string | DateTimeFieldRefInput<$PrismaModel> | null
    in?: Date[] | string[] | null
    notIn?: Date[] | string[] | null
    lt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    lte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gt?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    gte?: Date | string | DateTimeFieldRefInput<$PrismaModel>
    not?: NestedDateTimeNullableWithAggregatesFilter<$PrismaModel> | Date | string | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedDateTimeNullableFilter<$PrismaModel>
    _max?: NestedDateTimeNullableFilter<$PrismaModel>
  }

  export type NestedIntNullableFilter<$PrismaModel = never> = {
    equals?: number | IntFieldRefInput<$PrismaModel> | null
    in?: number[] | null
    notIn?: number[] | null
    lt?: number | IntFieldRefInput<$PrismaModel>
    lte?: number | IntFieldRefInput<$PrismaModel>
    gt?: number | IntFieldRefInput<$PrismaModel>
    gte?: number | IntFieldRefInput<$PrismaModel>
    not?: NestedIntNullableFilter<$PrismaModel> | number | null
  }

  export type NestedStringNullableFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel> | null
    in?: string[] | null
    notIn?: string[] | null
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringNullableFilter<$PrismaModel> | string | null
  }

  export type NestedStringNullableWithAggregatesFilter<$PrismaModel = never> = {
    equals?: string | StringFieldRefInput<$PrismaModel> | null
    in?: string[] | null
    notIn?: string[] | null
    lt?: string | StringFieldRefInput<$PrismaModel>
    lte?: string | StringFieldRefInput<$PrismaModel>
    gt?: string | StringFieldRefInput<$PrismaModel>
    gte?: string | StringFieldRefInput<$PrismaModel>
    contains?: string | StringFieldRefInput<$PrismaModel>
    startsWith?: string | StringFieldRefInput<$PrismaModel>
    endsWith?: string | StringFieldRefInput<$PrismaModel>
    not?: NestedStringNullableWithAggregatesFilter<$PrismaModel> | string | null
    _count?: NestedIntNullableFilter<$PrismaModel>
    _min?: NestedStringNullableFilter<$PrismaModel>
    _max?: NestedStringNullableFilter<$PrismaModel>
  }



  /**
   * Batch Payload for updateMany & deleteMany & createMany
   */

  export type BatchPayload = {
    count: number
  }

  /**
   * DMMF
   */
  export const dmmf: runtime.BaseDMMF
}