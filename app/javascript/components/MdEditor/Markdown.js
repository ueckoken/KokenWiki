import React from "react"
import { useSelector } from "react-redux"
import Markdown from "../Markdown"

const MarkdownForMdEditor = () => {
    const markdown = useSelector((state) => state.markdown)
    return <Markdown markdown={markdown} />
}

export default MarkdownForMdEditor
