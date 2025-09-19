import { IoMdCloseCircleOutline } from "react-icons/io";

import { Expense, Notification } from "../../types/BaseInterfaces";

interface Props {
  notification: Notification;
  expense: Expense;
}

const ExpenseUpdatedNotification = ({ notification, expense }: Props) => {
  return (
    <div className="flex gap-2 justify-between items-center items-start border-l-2 border-yellow-500  h-10 p-2 mb-2">
      <a href={notification.link}>
        <div className="text-sm font-bold">
          Expense updated for{" "}
          <span className="text-bold">{expense.group.name}</span>
        </div>

        <div className="text-xs">
          {expense.reference}:
          {Intl.NumberFormat("en-US", {
            style: "currency",
            currency: "USD",
          }).format(expense.amount)}
        </div>
      </a>

      <IoMdCloseCircleOutline size={20} />
    </div>
  );
};

export default ExpenseUpdatedNotification;
