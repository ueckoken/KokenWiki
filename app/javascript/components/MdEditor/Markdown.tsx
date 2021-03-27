import React, { FC } from "react"
import { useSelector } from "react-redux"
import type { State } from "../redux"
import Markdown from "../Markdown"

const MarkdownForMdEditor: FC<{}> = () => {
    const markdown = useSelector<State>((state) => state.markdown)
    return <Markdown markdown={markdown} />
}

export default MarkdownForMdEditor
