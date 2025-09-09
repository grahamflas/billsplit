import { useState } from "react";

import { Field, Form, Formik } from "formik";
import { MdOutlineEdit } from "react-icons/md";

import Modal from "./Modal";

import { format } from "date-fns";

import { Expense, Group } from "../types/BaseInterfaces";

import ExpenseEditForm from "./ExpenseEditForm";

interface Props {
  expense: Expense;
  group: Group;
  isOpen: boolean;
  onClose: () => void;
}

const ExpenseModal = ({ expense, group, isOpen, onClose }: Props) => {
  const [isEditing, setIsEditing] = useState(false);

  return (
    <Modal
      isOpen={isOpen}
      onCloseModal={onClose}
      title={isEditing ? `Edit ${expense.reference}` : expense.reference}
    >
      {isEditing ? (
        <ExpenseEditForm
          expense={expense}
          group={group}
          onCancel={() => setIsEditing(false)}
        />
      ) : (
        <>
          <div className="flex flex-row justify-end">
            <button onClick={() => setIsEditing(true)}>
              <MdOutlineEdit size={25} />
            </button>
          </div>

          <div className="flex flex-col gap-4 items-center">
            <div className="text-4xl">
              {Intl.NumberFormat("en-US", {
                style: "currency",
                currency: "USD",
              }).format(expense.amount)}
            </div>

            <div>{`Paid by ${expense.user.firstName} ${
              expense.user.lastName
            } on ${format(new Date(expense.createdAt), "MMM d, yyyy")}`}</div>
          </div>
        </>
      )}
    </Modal>
  );
};

export default ExpenseModal;
