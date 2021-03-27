import React from "react"
import { CheckIcon } from "@primer/octicons-react"

const SaveButton = ({ disabled }) => (
    <button
        type="submit"
        disabled={disabled}
        className="btn btn-primary btn-icon"
    >
        <CheckIcon />
    </button>
)

export default SaveButton
