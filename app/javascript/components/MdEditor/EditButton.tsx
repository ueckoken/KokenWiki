import React, { FC } from "react"
import { PencilIcon } from "@primer/octicons-react"

type Props = {
    onClick: (e: React.MouseEvent<HTMLElement>) => void
}

const EditButton: FC<Props> = ({ onClick }) => (
    <button
        type="button"
        className="btn btn-secondary btn-icon"
        onClick={onClick}
    >
        <PencilIcon />
    </button>
)

export default EditButton
