class DepartmentWorker < ApplicationRecord
  belongs_to :department
  belongs_to :worker

  validates :worker_id, uniqueness: true
  validates :status, presence: true

  enum :status, { worker: 0, manager: 1 }
end
