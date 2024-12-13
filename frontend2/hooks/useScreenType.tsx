import { getScreenType } from "#/utils/utils";
import { useEffect, useState } from "react";
import { Dimensions } from "react-native";

export const useScreenType = () => {
    const [ScreenType, setScreenType] = useState(getScreenType());

    useEffect(() => {
        const onResize = () => {
            setScreenType(getScreenType());
        }

        const onWindowChangeListener = Dimensions.addEventListener("change", onResize);
    
        return () => {
            onWindowChangeListener.remove();
        }
    }, []);
    
    return ScreenType;
}