import React, { FC } from "react"
import Markdown from "../Markdown"
import { useTypedSelector } from "../redux"

const MarkdownForMdEditor: FC<{}> = () => {
    const markdown = useTypedSelector((state) => state.markdown)
    return <Markdown markdown={markdown} />
}

export default MarkdownForMdEditor
