import React from "react"
import { useSelector } from "react-redux"
import Markdown from "../Markdown"

export default () => {
    const markdown = useSelector((state) => state.markdown)
    return <Markdown markdown={markdown} />
}
