import React, { FC, useCallback, useEffect } from "react"
import { selectors, useTypedSelector } from "../redux"

const WarnUnsavedChange: FC = () => {
    const is_changed = useTypedSelector(selectors.isChanged)
    const warnUnsavedChage = useCallback(
        (e: BeforeUnloadEvent) => {
            if (!is_changed) {
                return
            }
            e.preventDefault()
            e.returnValue = "" // non-standard but required by Chrome
        },
        [is_changed]
    )
    useEffect(() => {
        window.addEventListener("beforeunload", warnUnsavedChage)
        return () =>
            window.removeEventListener("beforeunload", warnUnsavedChage)
    }, [warnUnsavedChage])
    return null
}

export default WarnUnsavedChange
