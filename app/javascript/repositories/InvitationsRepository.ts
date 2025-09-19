import ajax from "../utils/ajax";

import { Invitation } from "../types/BaseInterfaces";

class InvitationsRepository {
  static readonly baseUrl = `/api/invitations`;

  static async accept(
    invitation: Invitation
  ): Promise<boolean> {
    try {

      await ajax.put(`${this.baseUrl}/${invitation.id}/accept`);

      return true;
    } catch (error) {
      return false;
    }
  }
}

export default InvitationsRepository;
