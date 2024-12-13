import { MD3Theme } from "react-native-paper"
import { MD3Colors } from "react-native-paper/lib/typescript/types"


export type Theme = MD3Theme & {
    colors: MD3Colors &{
        success: string,
        onSuccess: string,
        successContainer: string,
        onSuccessContainer: string,
    }
}



