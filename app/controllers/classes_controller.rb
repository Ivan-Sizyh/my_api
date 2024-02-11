class ClassesController < ApplicationController
  NEEDED_ATTRIBUTES = %w[id number letter]

  def index
    classes = SchoolClass.where(school_id: params[:school_id]).includes(:students)

    classes = classes.map do |klass|
      klass.attributes
           .slice(*NEEDED_ATTRIBUTES)
           .merge({ students_count: students_count(klass) })
    end

    render json: { data: classes }
  end

  private

  def students_count(my_class)
    my_class.students.size
  end
end
