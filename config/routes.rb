Rails.application.routes.draw do
  namespace :api do
    resources :products, except: [:show] do
      collection do
        get 'search', to: 'products#search'
        get 'approval-queue', to: 'products#approval_queue'
      end
    end

    put 'products/approval-queue/:approval_id/approve', to: 'approval_queues#approve'
    put 'products/approval-queue/:approval_id/reject', to: 'approval_queues#reject'
  end
end
