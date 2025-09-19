import { useState } from "react";

import { IoMdCloseCircleOutline } from "react-icons/io";

import { Notification, Settlement } from "../../types/BaseInterfaces";

interface Props {
  destroyNotification: (notification: Notification) => void;
  notification: Notification;
  settlement: Settlement;
}

const SettlementCreatedNotification = ({
  destroyNotification,
  notification,
  settlement,
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
      <div className="flex gap-2 justify-between items-center border-l-2 border-indigo-300 h-10 p-2 mb-2">
        <a onClick={handleLinkClick} href={notification.link}>
          <div className="text-sm font-bold">
            Settlement created for{" "}
            <span className="text-bold">{settlement.group.name}</span>
          </div>

          <div className="text-xs">
            Total expenses:
            {Intl.NumberFormat("en-US", {
              style: "currency",
              currency: "USD",
            }).format(settlement.balances.totalExpenses)}
          </div>
        </a>

        <IoMdCloseCircleOutline onClick={handleDismissClick} size={20} />
      </div>
    );
  }

  return null;
};

export default SettlementCreatedNotification;
