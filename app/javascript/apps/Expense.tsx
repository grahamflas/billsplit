import { useState } from "react";

import { format } from "date-fns";
import { BsBoxArrowUpRight } from "react-icons/bs";

import GroupDetailsData from "./GroupDetailsData";

import { Expense, Group } from "../types/BaseInterfaces";
import ExpenseModal from "./ExpenseModal";

interface Props {
  expense: Expense;
  group: Group;
  isInitialExpense: boolean;
}

const Expense = ({ expense, group, isInitialExpense }: Props) => {
  const [showExpenseModal, setShowExpenseModal] = useState(false);

  return (
    <>
      {!isInitialExpense && <hr />}

      <div
        className="flex justify-between items-center"
        id={`expense-${expense.id}`}
      >
        <GroupDetailsData
          headingData={
            <div className="flex gap-4 items-center">
              {expense.reference}

              <button onClick={() => setShowExpenseModal(true)} type="button">
                <BsBoxArrowUpRight size={15} />
              </button>
            </div>
          }
          headingClasses="text-2xl"
          subHeadingData={`Paid by ${expense.user.firstName} ${
            expense.user.lastName
          } on ${format(new Date(expense.createdAt), "MMM d, yyyy")}`}
          subHeadingClasses="text-neutral-500"
        />

        <div>
          <div className="text-2xl">${expense.amount}</div>
        </div>
      </div>

      <ExpenseModal
        expense={expense}
        group={group}
        isOpen={showExpenseModal}
        onClose={() => setShowExpenseModal(false)}
      />
    </>
  );
};

export default Expense;
