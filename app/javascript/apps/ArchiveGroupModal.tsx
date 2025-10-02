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

  return (
    <Modal
      id="archive-group-modal"
      isOpen={isOpen}
      onCloseModal={onClose}
      title={`Archive ${group.name}`}
    >
      <div className="flex flex-col items-center gap-6">
        <div className="flex flex-col items-center">
          <h1 className="text-2xl text-rose-600">Are you sure?</h1>

          <p>
            You're about to archive this group for you and all other members
          </p>
        </div>

        <div className="flex justify-between w-full">
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
      </div>
    </Modal>
  );
};

export default ArchiveGroupModal;
