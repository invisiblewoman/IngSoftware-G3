class QuestionCommentsController < ApplicationController
		before_action :authenticate_user!,except:[:create,:new]
  def index
  end

  def show
  end

  def new
  
    @question_comment = QuestionComment.new
    render :create
  end

  def create
    
    @question_comment = QuestionComment.new(
      params.require(:question_comment)
        .permit(:texto,:question_id)
    )
    @question_comment.question_id = params[:question_id]
    @question_comment.user = current_user
    @question_comment.fecha = Time.now 
    @question_comment.save
    @ganancia=Permiso.where(nombre:"Comentar",tipo:"Ganancia").first.cantidad
    @question_comment.user.votos = @question_comment.user.votos + @ganancia
    @question_comment.user.save
    redirect_to question_path(params[:question_id],:condicion => "0")

  end

 
  def edit
    
    @questioncomment =  QuestionComment.find(params[:id])
    redirect_to question_path(Question.find(@questioncomment.question_id).id,:condicion => "0", :editar => "2", :idaq => params[:id] )
       
  end

  def update

     @questioncomment =  QuestionComment.find(params[:id])
     @questioncomment.update(texto: params[:question_comment][:texto])
     redirect_to question_path(params[:question_id],:condicion => "0", :editar => "0")
  end

   def destroy
    questioncomment =  QuestionComment.find(params[:id])
    questioncomment.destroy
    redirect_to question_path(params[:question_id],:condicion => "0", :editar => "0") 
  end
end
