import { FaArrowLeft } from "react-icons/fa";
import GroupsRepository from "../repositories/GroupsRepository";
import { Group } from "../types/BaseInterfaces";
import Modal from "./Modal";

interface Props {
  group: Group;
  hasOpenExpenses: boolean;
  isOpen: boolean;
  onClose: () => void;
}

const ArchiveGroupModal = ({
  group,
  hasOpenExpenses,
  isOpen,
  onClose,
}: Props) => {
  const handleArchive = async () => {
    const success = await GroupsRepository.archive(group);

    if (success) {
      window.location.href = "/groups/archived";
    }
  };

  const renderModalContent = () => {
    if (hasOpenExpenses) {
      return (
        <div className="flex flex-col items-center">
          <h1 className="text-2xl text-rose-600 mb-6">
            {group.name} still has open expenses
          </h1>

          <p>Before archiving this group, please settle all open expenses.</p>

          <a
            className="mt-6 text-lg text-indigo-400 hover:text-indigo-500 focus:text-indigo-500"
            href={`/groups/${group.id}`}
          >
            Back to {group.name}
          </a>
        </div>
      );
    }

    return (
      <>
        <div className="flex flex-col items-center">
          <h1 className="text-2xl text-rose-600 mb-6">Are you sure?</h1>

          <p>
            You're about to archive this group for you and all other members
          </p>
        </div>

        <div className="flex justify-between w-full mt-6">
          <button
            className="rounded-md px-3 py-1 border border-indigo-400 hover:bg-neutral-100 focus:bg-neutral-300 text-indigo-500 text-center"
            type="button"
            onClick={onClose}
          >
            cancel
          </button>

          <button
            className="rounded-md px-3 py-1 bg-rose-400 hover:bg-rose-500 focus:bg-rose-500 text-white text-center"
            type="button"
            onClick={handleArchive}
            aria-label={`Archive ${group.name}`}
          >
            archive
          </button>
        </div>
      </>
    );
  };

  return (
    <Modal
      id="archive-group-modal"
      isOpen={isOpen}
      onCloseModal={onClose}
      title={`Archive ${group.name}`}
    >
      <div className="flex flex-col items-center gap-6">
        {renderModalContent()}
      </div>
    </Modal>
  );
};

export default ArchiveGroupModal;
