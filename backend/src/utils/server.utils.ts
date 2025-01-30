import http from "http";
import https from "https";
import { AddressInfo } from "net";
import { logger } from "#utils";
import { LOGLEVELS } from "#types/logger.types";

export const startServer = (server: http.Server | https.Server, port: number, label: string) => {  
    server.listen(port, () => {  
      const address = server.address() as AddressInfo;  
      const protocol = label.includes('HTTPS') ? 'https' : 'http';  
      const host = address?.address !== '::' ? address?.address : 'localhost';  
      logger.log({  
        level: LOGLEVELS.INFO,  
        message: `Server running in ${protocol}://${host}:${port}`,  
        label,  
        host,  
        protocol,  
        port,  
        url: `${protocol}://${host}:${port}`  
      });  
    });  
};


export const parse_json = (v:string) => {
  try{
      return JSON.parse(v);
  }catch(e) {
      logger.log({ level:LOGLEVELS.ERROR, message:"json parse failed: "+v+ " error: "+(e as Error).message, label:"parse_json" })
      return undefined;
  }
} 