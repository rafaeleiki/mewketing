module Services
  class GroupAPI < Grape::API
    version 'v1', using: :header, vendor: 'group'
    content_type :json, 'application/json;charset=utf-8'

    resource :group do
      # # CRUD - DB Management
      # desc 'Add a new '
      # params do
      #   requires , type: , desc: '  of '
      # end
      # post :add do
      #   if .find_by(: params[:]).nil?
      #     .create : params[:]
      #   end
      # end
      #
      # desc 'Read some  by selecting '
      # params do
      #   requires , type: , desc: '  of '
      # end
      # post :add do
      #   .find_by(params)
      # end
      #
      # desc 'Read all '
      # params do
      #   requires , type: , desc: '  of '
      # end
      # post :add do
      #   if .find_by(: params[:]).nil?
      #     .create(: params[:])
      #   end
      # end
      #
      # desc 'Update one '
      # params do
      #   requires , type: , desc: '  of '
      # end
      # post :add do
      #   if .find_by(: params[:]).nil?
      #     .create(: params[:])
      #   end
      # end
      #
      # desc 'Remove one '
      # params do
      #   requires , type: , desc: '  of '
      # end
      # post :add do
      #   if .find_by(: params[:]).nil?
      #     .create(: params[:])
      #   end
      # end

      # Receivers management
      desc 'Add a receiver to a group'
      params do
        requires :group_name, type: String, desc: 'Name of the group to add the receiver'
        requires :receiver_email, type: String, desc: 'Email of the receiver to be added'
      end
      post :add_receiver do
        g = Group.find_by(name: params[:group_name])
        r = Receiver.find_by(email: params[:receiver_email])
        if !(g.nil? || r.nil?)
          GroupReceiver.create(group: g, receiver: r)
        end
      end

      desc 'Remove a receiver from a group'
      params do
        requires :group_name, type: String, desc: 'Name of the group'
        requires :receiver_email, type: String, desc: 'Email of the receiver to be removed'
      end
      post :remove_receiver do
        g = Group.find_by(name: params[:group_name])
        r = Receiver.find_by(email: params[:receiver_email])
        if !(g.nil? || r.nil?)
          gr = GroupReceiver.find_by(group: g, receiver: r)
          gr.destroy unless gr.nil?
        end
      end
    end
  end
end
