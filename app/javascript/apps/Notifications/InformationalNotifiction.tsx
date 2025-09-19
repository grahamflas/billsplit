import React, { useState } from "react";

import { IoMdCloseCircleOutline } from "react-icons/io";

import { Notification } from "../../types/BaseInterfaces";

interface Props {
  destroyNotification: (notification: Notification) => void;
  mainText: string;
  notification: Notification;
  subText: string;
}

const InformationalNotification = ({
  destroyNotification,
  mainText,
  notification,
  subText,
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

  const borderColor = () => {
    switch (notification.category) {
      case "expense_added":
        return "border-emerald-500";
      case "expense_updated":
        return "border-yellow-500";
      case "settlement_created":
        return "border-indigo-400";
      default:
        "border-neutral-500";
    }
  };

  if (showNotification) {
    return (
      <div
        className={`flex gap-2 justify-between items-center border-2 ${borderColor()} border-y-0 border-r-0 h-10 p-2 mb-2`}
      >
        <a onClick={handleLinkClick} href={notification.link}>
          <div className="text-sm font-bold">{mainText}</div>

          <div className="text-xs">{subText}</div>
        </a>

        <IoMdCloseCircleOutline onClick={handleDismissClick} size={20} />
      </div>
    );
  }

  return null;
};

export default InformationalNotification;
