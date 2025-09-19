import { Invitation, Notification } from "../../types/BaseInterfaces";

interface Props {
  notification: Notification;
  invitation: Invitation;
}

const InvitationCreatedNotification = ({ notification, invitation }: Props) => {
  return (
    <div className="flex gap-6 justify-between items-center border-l-2 border-neutral-800  h-10 p-2 mb-2">
      <div className="text-sm font-bold">
        {invitation.creator.firstName} invited you to join{" "}
        {invitation.group.name}
      </div>
      <div className="flex gap-2">
        <button className="rounded-md px-3 py-1 bg-emerald-500 hover:bg-emerald-600 focus:bg-emerald-600 text-white text-center">
          Accept
        </button>

        <button className="rounded-md px-3 py-1 border border-rose-500 hover:bg-neutral-100 focus:bg-neutral-300 text-rose-500 text-center">
          Decline
        </button>
      </div>
    </div>
  );
};

export default InvitationCreatedNotification;
