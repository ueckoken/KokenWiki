import React from "react"
import { XIcon } from "@primer/octicons-react"

const CancelButton = ({ onClick }) => (
    <button
        type="button"
        className="btn btn-secoudary btn-icon"
        onClick={onClick}
    >
        <XIcon />
    </button>
)

export default CancelButton
