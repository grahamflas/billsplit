import ExpenseEditForm from "./ExpenseEditForm";
import Modal from "./Modal";

import { Expense, Group } from "../types/BaseInterfaces";
interface Props {
  expense: Expense;
  group: Group;
  isOpen: boolean;
  onClose: () => void;
}

const EditExpenseModal = ({ expense, group, isOpen, onClose }: Props) => {
  return (
    <Modal
      isOpen={isOpen}
      onCloseModal={onClose}
      title={`Edit ${expense.reference}`}
    >
      <ExpenseEditForm expense={expense} group={group} onCancel={onClose} />
    </Modal>
  );
};

export default EditExpenseModal;
