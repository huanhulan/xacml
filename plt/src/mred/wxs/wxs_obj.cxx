/* DO NOT EDIT THIS FILE. */
/* This file was generated by xctocc from "wxs_obj.xc". */


#if defined(_MSC_VER)
# include "wx.h"
#endif
#if defined(OS_X) && defined(MZ_PRECISE_GC)
# include "common.h"
#endif

#include "wx_obj.h"




#ifdef wx_x
# define BM_SELECTED(map) ((map)->selectedTo)
#endif
#if defined(wx_mac) || defined(wx_msw)
# define BM_SELECTED(map) ((map)->selectedInto)
#endif
# define BM_IN_USE(map) ((map)->selectedIntoDC)





#include "wxscheme.h"
#include "wxs_obj.h"

#ifdef MZ_PRECISE_GC
START_XFORM_SKIP;
#endif



class os_wxObject : public wxObject {
 public:

  os_wxObject CONSTRUCTOR_ARGS(());
  ~os_wxObject();
#ifdef MZ_PRECISE_GC
  void gcMark();
  void gcFixup();
#endif
};

#ifdef MZ_PRECISE_GC
void os_wxObject::gcMark() {
  wxObject::gcMark();
}
void os_wxObject::gcFixup() {
  wxObject::gcFixup();
}
#endif

static Scheme_Object *os_wxObject_class;

os_wxObject::os_wxObject CONSTRUCTOR_ARGS(())
CONSTRUCTOR_INIT(: wxObject())
{
}

os_wxObject::~os_wxObject()
{
    objscheme_destroy(this, (Scheme_Object *) __gc_external);
}

static Scheme_Object *os_wxObject_ConstructScheme(int n,  Scheme_Object *p[])
{
  SETUP_PRE_VAR_STACK(1);
  PRE_VAR_STACK_PUSH(0, p);
  os_wxObject *realobj INIT_NULLED_OUT;
  REMEMBER_VAR_STACK();

  SETUP_VAR_STACK_PRE_REMEMBERED(2);
  VAR_STACK_PUSH(0, p);
  VAR_STACK_PUSH(1, realobj);

  
  if (n != (POFFSET+0)) 
    WITH_VAR_STACK(scheme_wrong_count_m("initialization in object%", POFFSET+0, POFFSET+0, n, p, 1));

  
  realobj = WITH_VAR_STACK(new os_wxObject CONSTRUCTOR_ARGS(()));
#ifdef MZ_PRECISE_GC
  WITH_VAR_STACK(realobj->gcInit_wxObject());
#endif
  realobj->__gc_external = (void *)p[0];
  
  
  READY_TO_RETURN;
  ((Scheme_Class_Object *)p[0])->primdata = realobj;
  ((Scheme_Class_Object *)p[0])->primflag = 1;
  WITH_REMEMBERED_STACK(objscheme_register_primpointer(p[0], &((Scheme_Class_Object *)p[0])->primdata));
  return scheme_void;
}

void objscheme_setup_wxObject(Scheme_Env *env)
{
  SETUP_VAR_STACK(1);
  VAR_STACK_PUSH(0, env);

  wxREGGLOB(os_wxObject_class);

  os_wxObject_class = WITH_VAR_STACK(objscheme_def_prim_class(env, "object%", NULL, (Scheme_Method_Prim *)os_wxObject_ConstructScheme, 0));



  WITH_VAR_STACK(scheme_made_class(os_wxObject_class));


  READY_TO_RETURN;
}

int objscheme_istype_wxObject(Scheme_Object *obj, const char *stop, int nullOK)
{
  REMEMBER_VAR_STACK();
  if (nullOK && XC_SCHEME_NULLP(obj)) return 1;
  if (objscheme_is_a(obj,  os_wxObject_class))
    return 1;
  else {
    if (!stop)
       return 0;
    WITH_REMEMBERED_STACK(scheme_wrong_type(stop, nullOK ? "object% object or " XC_NULL_STR: "object% object", -1, 0, &obj));
    return 0;
  }
}

Scheme_Object *objscheme_bundle_wxObject(class wxObject *realobj)
{
  Scheme_Class_Object *obj INIT_NULLED_OUT;
  Scheme_Object *sobj INIT_NULLED_OUT;

  if (!realobj) return XC_SCHEME_NULL;

  if (realobj->__gc_external)
    return (Scheme_Object *)realobj->__gc_external;

  SETUP_VAR_STACK(2);
  VAR_STACK_PUSH(0, obj);
  VAR_STACK_PUSH(1, realobj);

  if ((sobj = WITH_VAR_STACK(objscheme_bundle_by_type(realobj, realobj->__type))))
    { READY_TO_RETURN; return sobj; }
  obj = (Scheme_Class_Object *)WITH_VAR_STACK(scheme_make_uninited_object(os_wxObject_class));

  obj->primdata = realobj;
  WITH_VAR_STACK(objscheme_register_primpointer(obj, &obj->primdata));
  obj->primflag = 0;

  realobj->__gc_external = (void *)obj;
  READY_TO_RETURN;
  return (Scheme_Object *)obj;
}

class wxObject *objscheme_unbundle_wxObject(Scheme_Object *obj, const char *where, int nullOK)
{
  if (nullOK && XC_SCHEME_NULLP(obj)) return NULL;

  REMEMBER_VAR_STACK();

  (void)objscheme_istype_wxObject(obj, where, nullOK);
  Scheme_Class_Object *o = (Scheme_Class_Object *)obj;
  WITH_REMEMBERED_STACK(objscheme_check_valid(NULL, NULL, 0, &obj));
  if (o->primflag)
    return (os_wxObject *)o->primdata;
  else
    return (wxObject *)o->primdata;
}

