import vine_message_provider from "#config/validation/vine_message_provider.js";
import { Vine } from "@vinejs/vine";


const vine_instance = new Vine();

vine_instance.convertEmptyStringsToNull=true;
vine_instance.messagesProvider = vine_message_provider;

export default vine_instance;