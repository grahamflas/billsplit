import { CiMenuKebab } from "react-icons/ci";

import EditPopoverTargetContent from "./EditPopoverTargetContent";

import { Popover, Trigger } from "@accessible/popover";

import { Expense } from "../types/BaseInterfaces";

interface Props {
  expense: Expense;
  onEdit: () => void;
  onDelete: () => void;
}

const ExpenseEditPopover = ({ expense, onEdit, onDelete }: Props) => {
  return (
    <Popover repositionOnScroll repositionOnResize>
      <EditPopoverTargetContent
        expense={expense}
        onEdit={onEdit}
        onDelete={onDelete}
      />

      <Trigger on="click">
        <button id={`edit-expense-${expense.id}`} type="button">
          <CiMenuKebab size={25} />
        </button>
      </Trigger>
    </Popover>
  );
};

export default ExpenseEditPopover;
