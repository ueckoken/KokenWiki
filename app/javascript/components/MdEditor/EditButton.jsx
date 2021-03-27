import React from "react"
import { PencilIcon } from "@primer/octicons-react"

const EditButton = ({ onClick }) => (
    <button
        type="button"
        className="btn btn-secondary btn-icon"
        onClick={onClick}
    >
        <PencilIcon />
    </button>
)

export default EditButton
