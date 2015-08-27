RailsAdmin.config do |config|


  ### Popular gems integration

  ## == Devise ==
   config.authenticate_with do
     warden.authenticate! scope: :user
   end
   config.current_user_method(&:current_user)

  ## == Cancan ==
   config.authorize_with :cancan

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/sferik/rails_admin/wiki/Base-configuration
   config.model 'Order' do
     list do
       field :user
       field :total_price
       field :state, :state
     end

     edit do
       configure :state, :state
       configure :completed_date do
         read_only true
       end
       configure :number do
         read_only true
       end
       configure :total_price do
         read_only true
       end
     end

     state({
               events: {ship: 'btn-warning', complete: 'btn-success', cancel: 'btn-danger'},
               states: {in_queue: 'label-info', in_delivery: 'label-warning', delivered: 'label-success'},
               disable: [:submit]
           })
   end




  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app
    state
    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end
end
