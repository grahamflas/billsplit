import { IoMdCloseCircleOutline } from "react-icons/io";

import { Expense, Notification } from "../../types/BaseInterfaces";

interface Props {
  notification: Notification;
  expense: Expense;
}

const ExpenseAddedNotification = ({ notification, expense }: Props) => {
  return (
    <div className="flex gap-2 justify-between items-center border-2 border-emerald-500 border-y-0 border-r-0 h-10 p-2 mb-2">
      <a href={notification.link}>
        <div className="text-sm font-bold">
          Expense added to{" "}
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

export default ExpenseAddedNotification;
