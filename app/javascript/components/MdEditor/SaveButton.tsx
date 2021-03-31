import React, { FC } from "react"
import { CheckIcon } from "@primer/octicons-react"

type Props = {
    disabled: boolean
}

const SaveButton: FC<Props> = ({ disabled }) => (
    <button
        type="submit"
        disabled={disabled}
        className="btn btn-primary btn-icon"
    >
        <CheckIcon />
    </button>
)

export default SaveButton
