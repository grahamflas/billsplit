import React, { useState } from "react";

import { IoMdCloseCircleOutline } from "react-icons/io";

import { Expense, Notification } from "../../types/BaseInterfaces";

interface Props {
  destroyNotification: (notification: Notification) => void;
  expense: Expense;
  notification: Notification;
}

const ExpenseAddedNotification = ({
  destroyNotification,
  notification,
  expense,
}: Props) => {
  const [showNotification, setShowNotification] = useState(true);

  const handleDismissClick = async () => {
    await destroyNotification(notification);
    setShowNotification(false);
  };

  const handleLinkClick = async (e: React.MouseEvent) => {
    e.preventDefault();
    destroyNotification(notification);
    window.location.href = notification.link;
  };

  if (showNotification) {
    return (
      <div className="flex gap-2 justify-between items-center border-2 border-emerald-500 border-y-0 border-r-0 h-10 p-2 mb-2">
        <a onClick={handleLinkClick} href={notification.link}>
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

        <IoMdCloseCircleOutline onClick={handleDismissClick} size={20} />
      </div>
    );
  }

  return null;
};

export default ExpenseAddedNotification;
