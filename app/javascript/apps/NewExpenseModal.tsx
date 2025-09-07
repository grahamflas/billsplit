import { Field, Form, Formik } from "formik";

import Modal from "./Modal";
import { Group } from "../types/BaseInterfaces";

interface Props {
  group: Group;
  handleModalClose: () => void;
  isOpen: boolean;
}

const NewExpenseModal = ({ group, handleModalClose, isOpen }: Props) => {
  const handleSumbit = (values) => {
    console.log(values);
  };

  return (
    <Modal
      isOpen={isOpen}
      onCloseModal={handleModalClose}
      title={`New Expense for ${group.name}`}
    >
      <Formik
        initialValues={{ reference: "", amount: "", userId: "" }}
        onSubmit={handleSumbit}
      >
        <Form className="flex flex-col">
          <label htmlFor="reference" className="text-gray-500">
            Reference
          </label>

          <Field
            className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
            name="reference"
            type="text"
          />

          <label htmlFor="amount" className="text-gray-500">
            Amount
          </label>

          <Field
            className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
            name="amount"
            type="number"
          />

          <label htmlFor="userId" className="text-gray-500">
            Paid by
          </label>

          <Field
            className="border border-indigo-50 rounded-md bg-indigo-50 focus:outline-indigo-400 px-3 py-2 w-full mb-6"
            name="userId"
            as="select"
          >
            {group.users.map((user) => (
              <option
                value={user.id}
                key={user.id}
              >{`${user.firstName} ${user.lastName}`}</option>
            ))}
          </Field>

          <button
            type="submit"
            className="w-full bg-indigo-400 hover:bg-indigo-600 focus:outline-indigo-900 rounded-md text-white py-2 mb-6 cursor:pointer"
          >
            Submit
          </button>
        </Form>
      </Formik>
    </Modal>
  );
};

export default NewExpenseModal;
