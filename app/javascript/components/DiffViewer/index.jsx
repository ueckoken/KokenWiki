import React from "react"
import DiffViewer from "react-diff-viewer"

export default ({ oldValue, newValue }) => (
    <DiffViewer oldValue={oldValue} newValue={newValue} splitView={false} />
)
