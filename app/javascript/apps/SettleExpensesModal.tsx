import { Expense } from "../types/BaseInterfaces";
import Modal from "./Modal";

interface Props {
  expenses: Expense[];
  isOpen: boolean;
  onClose: () => void;
  title: string;
}

const SettleExpensesModal = ({ isOpen, onClose, title }: Props) => {
  return <Modal isOpen={isOpen} onCloseModal={onClose} title={title}></Modal>;
};

export default SettleExpensesModal;
